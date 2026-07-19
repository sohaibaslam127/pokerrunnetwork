import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as location;
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';

class LocationServices {
  LocationServices._();
  static final LocationServices I = LocationServices._();

  final location.Location _location = location.Location();
  StreamSubscription<location.LocationData>? _locationSubscription;

  bool _isInitializing = false;

  /// Initializes location tracking.
  ///
  /// Features:
  /// - Prevents multiple simultaneous initialization calls
  /// - Handles service disabled state
  /// - Handles permission denied and denied forever
  /// - Updates Firestore only when user moves more than [miles]
  /// - Cancels previous listeners before starting a new one
  Future<bool> getUserLocation() async {
    if (_isInitializing) return false;

    _isInitializing = true;

    try {
      final bool ready = await _ensureLocationEnabledAndPermitted();

      if (!ready) {
        await stopListening();
        return false;
      }

      await _configureLocationSettings();
      await _startListening();
      return true;
    } catch (e, stackTrace) {
      log(
        'Error in getUserLocation()',
        error: e,
        stackTrace: stackTrace,
        name: 'LocationServices',
      );
      return false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Ensures:
  /// - Location service is enabled
  /// - Permission is granted
  ///
  /// Returns true if location can be accessed.
  Future<bool> _ensureLocationEnabledAndPermitted() async {
    try {
      // 1. Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();

      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();

        if (!serviceEnabled) {
          return false;
        }
      }

      // 2. Check permission
      location.PermissionStatus permission = await _location.hasPermission();

      // Handle denied
      if (permission == location.PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }

      // Handle permanently denied / denied forever / grantedLimited
      if (permission == location.PermissionStatus.granted ||
          permission == location.PermissionStatus.grantedLimited) {
        return true;
      }

      return false;
    } on TimeoutException catch (e, stackTrace) {
      log(
        'Location request timed out',
        error: e,
        stackTrace: stackTrace,
        name: 'LocationServices',
      );
      return false;
    }
  }

  /// Configures location tracking settings.
  Future<void> _configureLocationSettings() async {
    await _location.changeSettings(
      accuracy: location.LocationAccuracy.high,
      interval: 30000, // 30 seconds
      distanceFilter: miles * (1609.34 / 3), // miles to meters
    );
  }

  /// Starts listening to location changes.
  Future<void> _startListening() async {
    // Cancel existing subscription before starting a new one
    await stopListening();

    _locationSubscription = _location.onLocationChanged.listen(
      _handleLocationUpdate,
      onError: (error, stackTrace) {
        log(
          'Location stream error',
          error: error,
          stackTrace: stackTrace,
          name: 'LocationServices',
        );
      },
    );
  }

  /// Handles incoming location updates.
  Future<void> _handleLocationUpdate(location.LocationData locationData) async {
    final double? latitude = locationData.latitude;
    final double? longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      return;
    }

    final GeoPoint newLocation = GeoPoint(latitude, longitude);

    // If user location is not initialized yet
    if (currentUser.location.latitude == 0 &&
        currentUser.location.longitude == 0) {
      currentUser.location = newLocation;
      await FirestoreServices.I.updateLocation();
      return;
    }

    final double distanceMoved = await calculateDistance(
      currentUser.location.latitude,
      currentUser.location.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );

    // Always update local cache
    currentUser.location = newLocation;

    // Update Firestore only if moved more than threshold
    if (distanceMoved > miles) {
      await FirestoreServices.I.updateLocation();
    }
  }

  /// Stops listening to location updates.
  Future<void> stopListening() async {
    try {
      await _locationSubscription?.cancel();
    } catch (e, stackTrace) {
      log(
        'Error stopping location listener',
        error: e,
        stackTrace: stackTrace,
        name: 'LocationServices',
      );
    } finally {
      _locationSubscription = null;
    }
  }

  /// Returns whether location tracking is currently active.
  bool get isListening => _locationSubscription != null;
}
