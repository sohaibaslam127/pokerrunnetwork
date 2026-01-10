import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:location/location.dart" as LocationManager;
import 'package:app_settings/app_settings.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';

class LocationServices {
  static final LocationServices I = LocationServices._();
  LocationServices._();

  final LocationManager.Location _location = LocationManager.Location();
  StreamSubscription<LocationManager.LocationData>? _locationSubscription;

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          await AppSettings.openAppSettings(type: AppSettingsType.location);
          await Future.delayed(const Duration(seconds: 8));
          serviceEnabled = await _location.serviceEnabled();
          if (!serviceEnabled) {
            return;
          }
        }
      }
      LocationManager.PermissionStatus permissionGranted = await _location
          .hasPermission();
      if (permissionGranted == LocationManager.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != LocationManager.PermissionStatus.granted) {
          return;
        }
      }

      await _location.changeSettings(
        accuracy: LocationManager.LocationAccuracy.high,
        interval: 30000,
        distanceFilter: miles * (1609.34 / 3),
      );

      if (currentUser.id == "") return;
      await _locationSubscription?.cancel();

      _locationSubscription = _location.onLocationChanged.listen((
        locationData,
      ) async {
        if (locationData.latitude == null || locationData.longitude == null) {
          return;
        }
        final newPoint = GeoPoint(
          locationData.latitude!,
          locationData.longitude!,
        );

        final double distanceMoved = calculateDistance(
          currentUser.location.latitude,
          currentUser.location.longitude,
          newPoint.latitude,
          newPoint.longitude,
        );
        if (distanceMoved > miles) {
          currentUser.location = newPoint;
          await FirestoreServices.I.updateLocation();
        } else {
          currentUser.location = newPoint;
        }
      });
    } on TimeoutException catch (e, stack) {
      log('Location request timed out');
    } catch (e, stack) {
      log('Error occurred in getUserLocation()');
    }
  }

  Future<void> stopListening() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }
}
