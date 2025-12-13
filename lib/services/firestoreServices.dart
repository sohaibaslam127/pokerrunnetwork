import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/models/userModel.dart';

class FirestoreServices {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static final FirestoreServices I = FirestoreServices._();
  FirestoreServices._();

  Future<void> init() async {
    DocumentSnapshot dsnap = await _instance
        .collection('admin')
        .doc('info')
        .get();

    if (dsnap.exists) {
      final data = dsnap.data() as Map<String, dynamic>?;

      if (data != null) {
        if (data['number'] != null &&
            data['number'].toString().trim().isNotEmpty) {
          helpLineNumber = data['number'];
        }

        if (data['supportEmail'] != null &&
            data['supportEmail'].toString().trim().isNotEmpty) {
          helpLineEmail = data['supportEmail'];
        }

        if (data['serviceFee'] != null &&
            data['serviceFee'].toString().trim().isNotEmpty) {
          serviceFee = (data['serviceFee'] as num).toDouble();
        }

        if (data['website'] != null &&
            data['website'].toString().trim().isNotEmpty) {
          website = data['website'];
        }

        if (data['coriderFee'] != null &&
            data['coriderFee'].toString().trim().isNotEmpty) {
          coriderFee = (data['coriderFee'] as num).toDouble();
        }

        if (coriderFee == -1) {
          coriderFee = serviceFee;
        }

        // Not on the admin panel, only set from remote config
        if (data['defaultSponsor'] != null &&
            data['defaultSponsor'].toString().trim().isNotEmpty) {
          defaultSponsor = data['defaultSponsor'];
        }

        if (data['enableAds'] != null &&
            data['enableAds'].toString().trim().isNotEmpty) {
          enableAds = data['enableAds'];
        }

        if (data['latestAppVersion'] != null &&
            data['latestAppVersion'].toString().trim().isNotEmpty) {
          latestAppVersion = data['latestAppVersion'];
        }

        if (data['needApproval'] != null &&
            data['needApproval'].toString().trim().isNotEmpty) {
          needApproval = data['needApproval'];
        }
      }
    }
  }

  Future<bool> registerUser() async {
    try {
      await _instance
          .collection('userProfiles')
          .doc(currentUser.id)
          .set(currentUser.toJson());
      await _instance.collection('admin').doc('stats').update({
        'users': FieldValue.increment(1),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  void clearLocalData() {
    _instance.clearPersistence();
  }

  Future<bool> updateUser() async {
    try {
      await _instance
          .collection('userProfiles')
          .doc(currentUser.id)
          .update(currentUser.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateOrganizerCount() {
    _instance.collection('admin').doc('stats').update({
      'organizerCount': FieldValue.increment(1),
    });
  }

  Future<bool> updateLocation() async {
    if (currentUser.id == "") return false;
    try {
      await _instance
          .collection('userProfiles')
          .doc(currentUser.id)
          .update(currentUser.toJson());
      EasyLoading.dismiss();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser(String userId) async {
    if (userId == "") return UserModel();
    UserModel user = UserModel();
    try {
      DocumentSnapshot dsnap = await _instance
          .collection('userProfiles')
          .doc(userId)
          .get();
      if (dsnap.exists) {
        user = UserModel.toModel(dsnap.data() as Map<String, dynamic>);
      }
      if (!user.enable) {
        EasyLoading.showInfo("This account has been disabled.");
        return UserModel();
      }
    } catch (e) {
      return UserModel();
    }
    return user;
  }

  Future<bool> isRoadNameUnique(String roadName) async {
    try {
      EasyLoading.show();
      final snapshot = await _instance
          .collection('userProfiles')
          .where('roadName', isEqualTo: roadName)
          .limit(1)
          .get();
      EasyLoading.dismiss();
      return snapshot.docs.isEmpty;
    } catch (e) {
      EasyLoading.dismiss();
      return true;
    }
  }

  Future<GamePlayerModel> isValidCorider(String eventId) async {
    try {
      final snapshot = await _instance
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .where(
            'mycoRiderName',
            isEqualTo: currentUser.roadName.trim().toLowerCase(),
          )
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return GamePlayerModel();
      final data = snapshot.docs.first.data();
      return GamePlayerModel.toModel(data);
    } catch (e) {
      return GamePlayerModel();
    }
  }

  Future<bool> isRiderPayforCorider(String eventId, String roadName) async {
    try {
      final snapshot = await _instance
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .where('mycoRiderName', isEqualTo: roadName.trim().toLowerCase())
          .where('approved', isEqualTo: true)
          .count()
          .get();
      return (snapshot.count ?? 0) > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteAccount(String userId) async {
    await _instance.collection('userProfiles').doc(userId).delete();
  }

  Query getEvents() {
    return _instance
        .collection('events')
        //        .where('countryCode', isEqualTo: countryCode)
        .where('status', whereIn: [1])
        .orderBy('eventDate');
  }

  Query getMyEvents() {
    return _instance
        .collection('events')
        .where('ownerId', isEqualTo: currentUser.id)
        .where('status', whereIn: [0, 1])
        .orderBy('eventDate');
  }

  Query getEventsResults() {
    return _instance
        .collection('events')
        .where('ownerId', isEqualTo: currentUser.id)
        .where('status', whereIn: [2, 3])
        .orderBy('eventDate');
  }

  Future<List<EventModel>> getLatestEvent() async {
    try {
      List<EventModel> events = [];
      QuerySnapshot<Map<String, dynamic>> dsnaps;
      dsnaps = await _instance
          .collection('events')
          .where("userIds", arrayContains: currentUser.id)
          .where('status', whereIn: [1])
          .orderBy('eventDate')
          .get();
      if (dsnaps.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> item in dsnaps.docs) {
          events.add(EventModel.toModel(item.data()));
        }
      }
      return events;
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  Query getJoinEvents() {
    return _instance
        .collection('events')
        .where("userIds", arrayContains: currentUser.id)
        .where('status', whereIn: [1, 2])
        .orderBy('status')
        .orderBy('eventDate');
  }

  Query getActiveJoinEvents() {
    return _instance
        .collection('events')
        .where("userIds", arrayContains: currentUser.id)
        .where('status', whereIn: [1])
        .orderBy('status')
        .orderBy('eventDate');
  }

  Future<List<EventModel>> getAllMyEvents() async {
    List<EventModel> events = [];
    try {
      QuerySnapshot<Map<String, dynamic>> dsnap = await _instance
          .collection('events')
          .where('ownerId', isEqualTo: currentUser.id)
          .where('status', whereIn: [0, 1])
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> item in dsnap.docs) {
        if (item.exists) {
          EventModel post = EventModel.toModel(item.data());
          events.add(post);
        }
      }
    } catch (e) {
      return [];
    }
    return events;
  }

  Future<List<EventModel>> getAllJoinEvents() async {
    List<EventModel> events = [];
    try {
      QuerySnapshot<Map<String, dynamic>> dsnap = await _instance
          .collection('events')
          .where("userIds", arrayContains: currentUser.id)
          .orderBy('eventDate')
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> item in dsnap.docs) {
        if (item.exists) {
          EventModel post = EventModel.toModel(item.data());
          events.add(post);
        }
      }
    } catch (e) {
      print(e);
    }
    return events;
  }

  Query searchEvents(String key) {
    return _instance
        .collection('events')
        .where('countryCode', isEqualTo: countryCode)
        .where('status', whereIn: [1])
        .where("searchParameter", arrayContains: key.toLowerCase())
        .orderBy('eventDate');
  }

  Future<bool> setEvent(
    BuildContext context,
    EventModel post,
    bool? isJoin,
    bool changeCard, {
    bool mycoRider = false,
    String mycoRiderName = "",
    bool iamcoRider = false,
    bool isExtraCardCorider = false,
  }) async {
    try {
      if (post.id == "") {
        // New Event
        post.id = _instance.collection('events').doc().id;
        post.ownerId = currentUser.id;
        post.ownerImage = currentUser.image;
        post.ownerName = currentUser.name;
        post.countryCode = countryCode;

        if (currentUser.pokerRunCount == 0) {
          updateOrganizerCount();
        }

        await _instance.collection('admin').doc('stats').update({
          'pokerRunCount': FieldValue.increment(1),
        });

        await _instance
            .collection('admin')
            .doc('stats')
            .collection('location')
            .doc('countries')
            .set({
              countryCode: FieldValue.increment(1),
            }, SetOptions(merge: true));

        currentUser.pokerRunCount += 1;

        await _instance.collection('userProfiles').doc(currentUser.id).update({
          "pokerRunCount": FieldValue.increment(1),
        });

        await _instance
            .collection('events')
            .doc(post.id)
            .set(await post.toSaveJSON(), SetOptions(merge: true));
      } else {
        if (isJoin == null) {
          await _instance
              .collection('events')
              .doc(post.id)
              .update(await post.toSaveJSON());
        } else if (isJoin) {
          await _instance.collection('userProfiles').doc(post.ownerId).update({
            "riderCount": FieldValue.increment(1),
          });
          await _instance.collection('events').doc(post.id).update({
            'userIds': FieldValue.arrayUnion([currentUser.id]),
          });

          GamePlayerModel gamePlayer = GamePlayerModel();
          gamePlayer.userId = currentUser.id;
          gamePlayer.roadName = currentUser.roadName;
          gamePlayer.userName = currentUser.name;
          gamePlayer.userImage = currentUser.image;
          gamePlayer.currentLocation = currentUser.location;
          gamePlayer.changeCard = changeCard;
          gamePlayer.pokerId = post.id;
          gamePlayer.approved = !needApproval;
          gamePlayer.mycoRiderName = mycoRiderName;
          gamePlayer.mycoRider = mycoRider;
          gamePlayer.iamCoRider = iamcoRider;
          gamePlayer.isExtraCardCorider = isExtraCardCorider;

          await _instance
              .collection('events')
              .doc(post.id)
              .collection("participants")
              .doc(currentUser.id)
              .set(gamePlayer.toSaveJSON());
        } else {
          await _instance.collection('events').doc(post.id).update({
            'userIds': FieldValue.arrayRemove([currentUser.id]),
          });

          final participantRef = _instance
              .collection('events')
              .doc(post.id)
              .collection('participants')
              .doc(currentUser.id);

          final messagesRef = participantRef.collection('messages');
          final messagesSnapshot = await messagesRef.get();
          for (final doc in messagesSnapshot.docs) {
            await doc.reference.delete();
          }

          await participantRef.delete();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateGamePlayer(GamePlayerModel game) async {
    try {
      await _instance
          .collection('events')
          .doc(game.pokerId)
          .collection("participants")
          .doc(game.userId)
          .update(game.toSaveJSON());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<GamePlayerModel> getGamePlayer(String pokerId, String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> data = await _instance
          .collection('events')
          .doc(pokerId)
          .collection("participants")
          .doc(userId)
          .get();
      if (data.exists) {
        return GamePlayerModel.toModel(data.data() ?? {});
      } else {
        return GamePlayerModel();
      }
    } catch (e) {
      return GamePlayerModel();
    }
  }

  Future<GamePlayerModel?> getGameWinner(String pokerId) async {
    try {
      final snapshot = await _instance
          .collection('events')
          .doc(pokerId)
          .collection('participants')
          .orderBy('rankValue', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return null;
      final data = snapshot.docs.first.data();
      return GamePlayerModel.toModel(data);
    } catch (e) {
      return null;
    }
  }

  Query getGamePlayers(String pokerId, String search) {
    if (search.isEmpty) {
      return _instance
          .collection('events')
          .doc(pokerId)
          .collection("participants")
          .orderBy('rankValue', descending: true);
    } else {
      return _instance
          .collection('events')
          .doc(pokerId)
          .collection("participants")
          .where("searchParameter", arrayContains: search.toLowerCase())
          .orderBy('approved', descending: false);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> newPlayerStatus(String pokerId) {
    return _instance
        .collection('events')
        .doc(pokerId)
        .collection("participants")
        .where('approved', isEqualTo: false)
        .snapshots();
  }

  Future<void> deleteEvent(String pokerId) async {
    final eventRef = FirebaseFirestore.instance
        .collection('events')
        .doc(pokerId);
    final participantsRef = eventRef.collection('participants');
    const int batchSize = 500;
    bool done = false;
    while (!done) {
      final snapshot = await participantsRef.limit(batchSize).get();
      if (snapshot.docs.isEmpty) {
        done = true;
        break;
      }
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    await eventRef.delete();
  }
}
