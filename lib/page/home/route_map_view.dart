import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/stops.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RouteMapView extends StatefulWidget {
  final EventModel event;
  // Indices into event.stops for the middle stops in play order.
  // e.g. [5, 1, 2, 3, 4] means the player started at stop 5.
  // Empty = show stops in original order.
  final List<int> routeSequence;
  const RouteMapView(this.event, {this.routeSequence = const [], super.key});

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  static final _routingChannel = MethodChannel('apple_maps_routing');

  // Ordered list: [Initial, ...middle in play order..., Final]
  late final List<StopsModel> _orderedStops;
  InAppWebViewController? _webViewController;
  StreamSubscription<LocationData>? _locationSub;

  // null = still loading, [] = no routes needed
  List<List<List<double>>>? _routeSegments;
  // 'green' for first/last segment, 'gold' for middle segments
  List<String> _segmentColors = [];

  @override
  void initState() {
    super.initState();
    _buildOrderedStops();
    _fetchRoutes();
  }

  void _buildOrderedStops() {
    bool isValid(StopsModel s) =>
        s.stopLocation.latitude != 0.0 || s.stopLocation.longitude != 0.0;

    final allValid = widget.event.stops.where(isValid).toList();

    if (widget.routeSequence.isEmpty || allValid.length < 3) {
      _orderedStops = allValid;
      return;
    }

    final start = widget.event.stops.first;
    final end = widget.event.stops.last;
    final ordered = <StopsModel>[start];
    for (final idx in widget.routeSequence) {
      if (idx > 0 && idx < widget.event.stops.length - 1) {
        final s = widget.event.stops[idx];
        if (isValid(s)) ordered.add(s);
      }
    }
    ordered.add(end);
    _orderedStops = ordered;
  }

  Future<void> _fetchRoutes() async {
    debugPrint('[RouteMap] orderedStops=${_orderedStops.length}');

    if (_orderedStops.length < 2) {
      if (mounted) setState(() => _routeSegments = []);
      return;
    }

    final segments = <List<List<double>>>[];
    final colors = <String>[];
    final totalSegments = _orderedStops.length - 1;

    for (int i = 0; i < totalSegments; i++) {
      final p1 = _orderedStops[i];
      final p2 = _orderedStops[i + 1];
      final coords = Platform.isIOS
          ? await _fetchAppleRoute(
              p1.stopLocation.latitude,
              p1.stopLocation.longitude,
              p2.stopLocation.latitude,
              p2.stopLocation.longitude,
            )
          : await _fetchGoogleRoute(
              p1.stopLocation.latitude,
              p1.stopLocation.longitude,
              p2.stopLocation.latitude,
              p2.stopLocation.longitude,
            );
      segments.add(coords);
      // First leg (Initial→first stop) and last leg (last stop→Final) = green
      colors.add(i == 0 || i == totalSegments - 1 ? 'green' : 'gold');
    }

    if (mounted) {
      setState(() {
        _routeSegments = segments;
        _segmentColors = colors;
      });
    }
  }

  Future<List<List<double>>> _fetchAppleRoute(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) async {
    try {
      final raw = await _routingChannel.invokeMethod<List>('getWalkingRoute', {
        'lat1': lat1,
        'lng1': lng1,
        'lat2': lat2,
        'lng2': lng2,
      });
      return raw!
          .map((c) => (c as List).map((v) => (v as num).toDouble()).toList())
          .toList();
    } catch (e) {
      debugPrint('[RouteMap] Apple MKDirections failed: $e');
      return [
        [lat1, lng1],
        [lat2, lng2],
      ];
    }
  }

  Future<List<List<double>>> _fetchGoogleRoute(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) async {
    const apiKey = 'AIzaSyBe5djPy8Cpm6fZMl14cmjw4ZewHtKFPI0';
    try {
      final res = await Dio().get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '$lat1,$lng1',
          'destination': '$lat2,$lng2',
          'mode': 'walking',
          'key': apiKey,
        },
      );
      final routes = res.data['routes'] as List?;
      if (routes == null || routes.isEmpty)
        return [
          [lat1, lng1],
          [lat2, lng2],
        ];
      final encoded = routes[0]['overview_polyline']['points'] as String;
      return _decodePolyline(encoded);
    } catch (e) {
      debugPrint('[RouteMap] Google Directions failed: $e');
      return [
        [lat1, lng1],
        [lat2, lng2],
      ];
    }
  }

  List<List<double>> _decodePolyline(String encoded) {
    final result = <List<double>>[];
    int index = 0, lat = 0, lng = 0;
    while (index < encoded.length) {
      int shift = 0, b = 0, result0 = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1);
      shift = 0;
      result0 = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1);
      result.add([lat / 1e5, lng / 1e5]);
    }
    return result;
  }

  Future<void> _startLocationUpdates() async {
    final loc = Location();
    bool serviceEnabled = await loc.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await loc.requestService();
    if (!serviceEnabled) return;

    PermissionStatus permission = await loc.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await loc.requestPermission();
    }
    if (permission != PermissionStatus.granted) return;

    await loc.changeSettings(accuracy: LocationAccuracy.high, interval: 3000);

    _locationSub = loc.onLocationChanged.listen((data) {
      final lat = data.latitude;
      final lng = data.longitude;
      final acc = data.accuracy ?? 10.0;
      if (lat == null || lng == null) return;
      _webViewController?.evaluateJavascript(
        source: 'updateUserMarker(L.latLng($lat, $lng), $acc);',
      );
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  String _buildHtml() {
    final points = _orderedStops.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      final isStart = i == 0;
      final isEnd = i == _orderedStops.length - 1;
      // Show the real stop number from the original stops list
      final actualIdx = widget.event.stops.indexOf(s);
      final label = isStart
          ? 'S'
          : isEnd
          ? 'F'
          : '$actualIdx';
      return {
        'lat': s.stopLocation.latitude,
        'lng': s.stopLocation.longitude,
        'name': s.name,
        'address': s.address,
        'label': label,
        'isStart': isStart,
        'isEnd': isEnd,
      };
    }).toList();

    final pointsJson = jsonEncode(points);
    final initialLat = currentUser.location.latitude;
    final initialLng = currentUser.location.longitude;

    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<style>
  html, body, #map { height: 100%; width: 100%; margin: 0; padding: 0; background: #f4f4f5; }
  .stop-marker {
    display: flex; align-items: center; justify-content: center;
    width: 30px; height: 30px; border-radius: 50%;
    background: rgba(255,255,255,0.95);
    color: #1a3b70; font-weight: 700; font-size: 13px;
    border: 2px solid #ffffff;
    box-shadow: 0 2px 6px rgba(0,0,0,0.25);
  }
  .stop-marker.start { background: #2ecc71; color: #ffffff; }
  .stop-marker.end { background: #000000; color: #ffffff; }
  
  .live-location-marker {
    display: flex; align-items: center; justify-content: center;
  }
  .pulse-dot {
    width: 12px; height: 12px; background-color: #007AFF; border-radius: 50%;
    border: 2px solid white; box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
    position: relative;
  }
  .pulse-dot::after {
    content: ''; width: 24px; height: 24px; background-color: rgba(0, 122, 255, 0.4);
    border-radius: 50%; position: absolute; top: -8px; left: -8px;
    animation: pulse 1.8s infinite ease-out;
  }
  @keyframes pulse {
    0% { transform: scale(0.5); opacity: 1; }
    100% { transform: scale(1.5); opacity: 0; }
  }

  .leaflet-popup-content-wrapper {
    background: #ffffff; color: #1c1c1f; border-radius: 10px;
    box-shadow: 0 3px 14px rgba(0,0,0,0.15);
  }
  .leaflet-popup-tip { background: #ffffff; }
  .leaflet-popup-content { margin: 10px 12px; font-family: -apple-system, system-ui, sans-serif; font-size: 13px; }
  .leaflet-popup-content b { color: #EF6C4A; }
  .leaflet-control-attribution { background: rgba(255,255,255,0.6) !important; color: #666 !important; font-size: 9px !important; }
  .leaflet-control-attribution a { color: #444 !important; }
</style>
</head>
<body>
<div id="map"></div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet-polylinedecorator@1.6.0/dist/leaflet.polylineDecorator.js"></script>
<script>
  const points = $pointsJson;
  const map = L.map('map', { zoomControl: false, attributionControl: true });

  // Google satellite (lyrs=s = pure imagery, no POI/labels)
  L.tileLayer('https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
    attribution: '&copy; Google Maps',
    subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
    maxNativeZoom: 20,
    maxZoom: 20
  }).addTo(map);

  // Road & address labels only — no POI clutter
  L.tileLayer('https://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; CARTO',
    subdomains: 'abcd',
    maxNativeZoom: 19,
    maxZoom: 20
  }).addTo(map);

  // Start Icon (Golf Flag)
  const startIconSvg = `
<svg width="22" height="22" viewBox="-3 0 20 20" xmlns="http://www.w3.org/2000/svg"
  style="display:inline-block; vertical-align:middle; margin-bottom:2px;"
>
  <g transform="translate(-5 -2)">
    <path fill="#1e428a" d="M12,4v6l6-3Z"/>
    <path d="M12,13c-3.31,0-6,1.79-6,4s2.69,4,6,4,6-1.79,6-4a3.59,3.59,0,0,0-2-3" fill="none" stroke="#1e428a" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
    <path d="M12,3V17M12,4v6l6-3Z" fill="none" stroke="#1e428a" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
  </g>
</svg>
`;

  // Finish Race Icon (Checkered Flag with Black & White Checks)
  const finishIconSvg = `
<svg
  viewBox="-3 0 24 24"
  width="22"
  height="22"
  fill="currentColor"
  style="display:inline-block; vertical-align:middle; margin-bottom:2px;"
>
  <!-- Flag Pole -->
  <path d="M6 2a1 1 0 0 1 1 1v18a1 1 0 1 1-2 0V3a1 1 0 0 1 1-1z"/>

  <!-- Checkered Flag White Base -->
  <path d="M7 4h10v8H7V4z"/>

  <!-- Black Checkered Squares -->
  <path
    d="M7 4h2.5v2.5H7zm5 0h2.5v2.5H12zm-2.5 2.5h2.5v2.5H9.5zm5 0H17v2.5H14.5zm-7.5 2.5h2.5v2.5H7zm5 0h2.5v2.5H12z"
    fill="#000000"
  />
</svg>
`;

  const latlngs = [];
  points.forEach(p => {
    const cls = p.isStart ? 'stop-marker start' : (p.isEnd ? 'stop-marker end' : 'stop-marker');
    let markerContent = p.label;
    if (p.isStart) {
      markerContent = startIconSvg;
    } else if (p.isEnd) {
      markerContent = finishIconSvg;
    }
    const icon = L.divIcon({
      className: '',
      html: '<div class="' + cls + '">' + markerContent + '</div>',
      iconSize: [30, 30],
      iconAnchor: [15, 15],
      popupAnchor: [0, -16]
    });
    const m = L.marker([p.lat, p.lng], { icon }).addTo(map);
    const title = p.isStart ? 'Start Point' : (p.isEnd ? 'End Point' : 'Stop ' + p.label);
    m.bindPopup('<b>' + title + '</b><br/>' + (p.name || '') + '<br/><span style="color:#666">' + (p.address || '') + '</span>');
    latlngs.push([p.lat, p.lng]);
  });

  if (latlngs.length === 1) {
    map.setView(latlngs[0], 16);
  } else if (latlngs.length === 0) {
    map.setView([0, 0], 2);
  } else {
    map.fitBounds(L.latLngBounds(latlngs), { padding: [40, 40] });
  }

  // Route segments pre-fetched natively (green=first/last leg, gold=middle legs)
  const routeSegments = ${jsonEncode(_routeSegments ?? [])};
  const segmentColors = ${jsonEncode(_segmentColors)};

  function drawSegment(coords, outlineColor, pathColor) {
    L.polyline(coords, {
      color: outlineColor,
      weight: 6,
      opacity: 0.9,
      lineCap: 'round',
      lineJoin: 'round'
    }).addTo(map);

    const line = L.polyline(coords, {
      color: pathColor,
      weight: 4,
      opacity: 1.0,
      lineCap: 'round',
      lineJoin: 'round'
    }).addTo(map);

    // Directional arrow at the midpoint of each segment
    L.polylineDecorator(line, {
      patterns: [{
        offset: '50%',
        repeat: 0,
        symbol: L.Symbol.arrowHead({
          pixelSize: 14,
          polygon: false,
          pathOptions: {
            stroke: true,
            color: '#ffffff',
            weight: 2.5,
            opacity: 0.95,
            fill: false
          }
        })
      }]
    }).addTo(map);
  }

  routeSegments.forEach((coords, idx) => {
    const isGreen = segmentColors[idx] === 'green';
    drawSegment(coords, isGreen ? '#1a6b3c' : '#113559', isGreen ? '#2ecc71' : '#F0C11D');
  });

  // Live Location
  let userLatLng = null;
  let userMarker = null;
  let userCircle = null;

  function updateUserMarker(latlng, accuracy) {
    userLatLng = latlng;
    const radius = accuracy / 2;
    if (userMarker) {
      userMarker.setLatLng(latlng);
      userCircle.setLatLng(latlng).setRadius(radius);
    } else {
      const liveIcon = L.divIcon({
        className: 'live-location-marker',
        html: '<div class="pulse-dot"></div>',
        iconSize: [20, 20],
        iconAnchor: [10, 10]
      });
      userMarker = L.marker(latlng, { icon: liveIcon }).addTo(map);
      userCircle = L.circle(latlng, radius, {
        color: '#007AFF',
        fillColor: '#007AFF',
        fillOpacity: 0.1,
        weight: 1
      }).addTo(map);
    }
  }

  function centerOnUser() {
    if (userLatLng) {
      map.setView(userLatLng, 16);
    } else {
      map.locate({ setView: true, maxZoom: 16 });
    }
  }

  // Initialize from Dart data if available
  const initialLat = $initialLat;
  const initialLng = $initialLng;
  if (initialLat !== 0 && initialLng !== 0) {
    userLatLng = L.latLng(initialLat, initialLng);
    updateUserMarker(userLatLng, 10);
  }

  map.on('locationfound', function(e) {
    userLatLng = e.latlng;
    updateUserMarker(e.latlng, e.accuracy);
  });

  map.on('locationerror', function(e) {
    console.warn("Geolocation error: " + e.message);
  });

  map.locate({ setView: false, watch: true, enableHighAccuracy: true });
</script>
</body>
</html>
''';
  }

  Future<void> _openInExternalMap() async {
    if (_orderedStops.isEmpty) return;
    final maps = await MapLauncher.installedMaps;
    if (maps.isEmpty) {
      if (!mounted) return;
      toast(context, "No map app", "No maps app is installed on this device");
      return;
    }

    final origin = _orderedStops.first;
    final destination = _orderedStops.last;
    final waypoints = _orderedStops.length > 2
        ? _orderedStops
              .sublist(1, _orderedStops.length - 1)
              .map(
                (s) => Waypoint(
                  s.stopLocation.latitude,
                  s.stopLocation.longitude,
                  s.name,
                ),
              )
              .toList()
        : <Waypoint>[];

    Future<void> launch(AvailableMap m) async {
      await m.showDirections(
        destination: Coords(
          destination.stopLocation.latitude,
          destination.stopLocation.longitude,
        ),
        destinationTitle: destination.name.isEmpty ? "End" : destination.name,
        origin: Coords(
          origin.stopLocation.latitude,
          origin.stopLocation.longitude,
        ),
        originTitle: origin.name.isEmpty ? "Start" : origin.name,
        waypoints: waypoints,
        directionsMode: DirectionsMode.walking,
      );
    }

    if (maps.length == 1) {
      await launch(maps.first);
      return;
    }

    if (!mounted) return;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: CupertinoActionSheet(
          actions: maps
              .map(
                (e) => Container(
                  color: MyColors.black,
                  child: CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(context);
                      await launch(e);
                    },
                    child: text_widget(
                      "Open in ${e.mapName}",
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              )
              .toList(),
          cancelButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colors.black26,
            ),
            child: CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: text_widget(
                'Cancel',
                color: MyColors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background/darkbackground.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            leadingWidth: 9.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 2.5, left: 1.5.w),
              child: onPress(
                ontap: () {
                  Get.back();
                },
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 25.sp,
                  color: MyColors.white,
                ),
              ),
            ),
            title: text_widget(
              "Preview Route",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
          ),
          body: _orderedStops.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: text_widget(
                      "No stop locations are available for this Poker Run yet.",
                      fontSize: 14.sp,
                      color: MyColors.white.withValues(alpha: 0.7),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _routeSegments == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: MyColors.primary),
                      SizedBox(height: 1.5.h),
                      text_widget(
                        "Calculating walking route...",
                        fontSize: 13.sp,
                        color: MyColors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    InAppWebView(
                      initialData: InAppWebViewInitialData(
                        data: _buildHtml(),
                        mimeType: 'text/html',
                        encoding: 'utf-8',
                        baseUrl: WebUri('https://localhost'),
                      ),
                      initialSettings: InAppWebViewSettings(
                        transparentBackground: true,
                        javaScriptEnabled: true,
                        supportZoom: true,
                      ),
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                      onLoadStop: (controller, url) {
                        _startLocationUpdates();
                      },
                      onGeolocationPermissionsShowPrompt:
                          (controller, origin) async {
                            return GeolocationPermissionShowPromptResponse(
                              origin: origin,
                              allow: true,
                              retain: true,
                            );
                          },
                    ),
                    Positioned(
                      right: 4.w,
                      bottom: 12.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMapControl(
                            icon: RemixIcons.add_line,
                            ontap: () => _webViewController?.evaluateJavascript(
                              source: "map.zoomIn();",
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          _buildMapControl(
                            icon: RemixIcons.subtract_line,
                            ontap: () => _webViewController?.evaluateJavascript(
                              source: "map.zoomOut();",
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          _buildMapControl(
                            icon: RemixIcons.focus_3_line,
                            color: const Color(0xFFEF6C4A),
                            ontap: () => _webViewController?.evaluateJavascript(
                              source: "centerOnUser();",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 4.w,
                      right: 4.w,
                      bottom: 4.h,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                    ),
                                  ),
                                  child: text_widget(
                                    "${_orderedStops.length - 2} stop${_orderedStops.length - 2 == 1 ? '' : 's'} • green = start/end legs, gold = middle stops",
                                    fontSize: 14.sp,
                                    color: Colors.white.withValues(alpha: 0.75),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              onPress(
                                ontap: _openInExternalMap,
                                child: Container(
                                  width: 11.w,
                                  height: 11.w,
                                  // padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF6C4A),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    RemixIcons.external_link_line,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback ontap,
    Color? color,
  }) {
    return onPress(
      ontap: ontap,
      child: Container(
        width: 11.w,
        height: 11.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color ?? const Color(0xFF1C1C1F), size: 18.sp),
      ),
    );
  }
}
