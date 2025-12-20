import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/models/userModel.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final AuthServices I = AuthServices._();
  AuthServices._();

  Future<String> emailSignIn(String user, String password) async {
    try {
      EasyLoading.show();
      UserCredential fbUser = await _auth.signInWithEmailAndPassword(
        email: user,
        password: password,
      );
      EasyLoading.dismiss();
      if (fbUser.user != null) {
        currentUser.id = fbUser.user!.uid;
        currentUser.email = fbUser.user!.email!;
        return "";
      }
      return "error";
    } on FirebaseAuthException catch (error) {
      EasyLoading.dismiss();
      return error.message ?? error.code;
    }
  }

  Future<String> emailSignUp(String email, password) async {
    try {
      EasyLoading.show();
      UserCredential fbUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      EasyLoading.dismiss();
      if (fbUser.user != null) {
        currentUser.id = fbUser.user!.uid;
        return "";
      }
      return "error";
    } on FirebaseAuthException catch (error) {
      EasyLoading.dismiss();
      return error.message ?? error.code;
    }
  }

  Future<String> sendEmailVarification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return "";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  static bool emailVarification() {
    try {
      return FirebaseAuth.instance.currentUser!.emailVerified;
    } catch (e) {
      return false;
    }
  }

  Future<String> forgetPassword(String mail) async {
    try {
      EasyLoading.show();
      await _auth.sendPasswordResetEmail(email: mail);
      EasyLoading.dismiss();
      return "";
    } on FirebaseAuthException catch (error) {
      EasyLoading.dismiss();
      return error.message ?? error.code;
    }
  }

  Future<void> checkUser() async {
    User? fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      currentUser = await FirestoreServices.I.getUser(fbUser.uid);
      currentUser.id = fbUser.uid;
      currentUser.email = fbUser.email ?? "";
      if (currentUser.id != "") {
        currentUser.lastAppOpen = DateTime.now();
        await FirestoreServices.I.updateUser();
      } else {
        await logOut();
      }
    } else {
      await logOut();
    }
  }

  Future<void> logOut() async {
    try {
      if (currentUser.id != "") {
        currentUser.isUser = null;
        await FirestoreServices.I.updateUser();
      }
      await _auth.signOut();
      currentUser = UserModel();
    } catch (e) {
      currentUser = UserModel();
    }
  }
}
