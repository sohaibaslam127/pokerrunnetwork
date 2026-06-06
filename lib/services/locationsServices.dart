import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as location;
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';

class LocationServices {
  LocationServices._();
  static final LocationServices I = LocationServices._();

  final location.Location _location = location.Location();
  bool _isInitializing = false;

  Future<void> getUserLocation() async {
    if (_isInitializing) return;

    _isInitializing = true;

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
      }

      location.PermissionStatus permission = await _location.hasPermission();
      if (permission == location.PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }

      bool deviceLocationSuccess = false;

      if (serviceEnabled &&
          (permission == location.PermissionStatus.granted ||
              permission == location.PermissionStatus.grantedLimited)) {
        try {
          final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 8),
          );
          final double? latitude = locationData.latitude;
          final double? longitude = locationData.longitude;

          if (latitude != null && longitude != null) {
            currentUser.location = GeoPoint(latitude, longitude);
            await FirestoreServices.I.updateLocation();
            deviceLocationSuccess = true;
          }
        } catch (e, stackTrace) {
          log(
            'Device location fetch failed, falling back to IP geolocation',
            error: e,
            stackTrace: stackTrace,
            name: 'LocationServices',
          );
        }
      }

      if (!deviceLocationSuccess) {
        final internetLoc = await _getInternetLocation();
        if (internetLoc != null) {
          currentUser.location = internetLoc;
          await FirestoreServices.I.updateLocation();
        }
        await _showPermissionDialog();
      }
    } catch (e, stackTrace) {
      log(
        'Error in getUserLocation()',
        error: e,
        stackTrace: stackTrace,
        name: 'LocationServices',
      );
    } finally {
      _isInitializing = false;
    }
  }

  /// Attempts to fetch location using IP geolocation.
  Future<GeoPoint?> _getInternetLocation() async {
    try {
      final dioInstance = dio.Dio();
      dioInstance.options.connectTimeout = const Duration(seconds: 5);
      dioInstance.options.receiveTimeout = const Duration(seconds: 5);

      final response = await dioInstance.get('https://ipapi.co/json/');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final double lat = toDouble(data['latitude']);
        final double lng = toDouble(data['longitude']);
        if (lat != 0.0 || lng != 0.0) {
          return GeoPoint(lat, lng);
        }
      }
    } catch (_) {
      // Fallback backup IP geolocation API
      try {
        final response = await dio.Dio().get('http://ip-api.com/json');
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          final double lat = toDouble(data['lat']);
          final double lng = toDouble(data['lon']);
          if (lat != 0.0 || lng != 0.0) {
            return GeoPoint(lat, lng);
          }
        }
      } catch (e, stackTrace) {
        log(
          'Error getting location by internet (backup)',
          error: e,
          stackTrace: stackTrace,
          name: 'LocationServices',
        );
      }
    }
    return null;
  }

  /// Opens a dialog warning the user that location is needed to organize the event.
  /// Does not close the app when cancelled.
  Future<void> _showPermissionDialog() async {
    if (Get.context == null) return;
    showPopup(
      Get.context!,
      "You need the location to organized the event. Please enable location services and permissions.",
      PopupActionsButtons.cancel,
      PopupActionsButtons.enable,
      () {
        Get.back();
      },
      () async {
        Get.back();
        await AppSettings.openAppSettings(type: AppSettingsType.location);
      },
    );
  }

  /// Dummy method for compatibility.
  Future<void> stopListening() async {}

  /// Dummy getter for compatibility.
  bool get isListening => false;
}
