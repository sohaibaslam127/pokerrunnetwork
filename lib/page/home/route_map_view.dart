import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
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
  const RouteMapView(this.event, {super.key});

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  late final List<StopsModel> _validStops;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _validStops = widget.event.stops
        .where(
          (s) =>
              s.stopLocation.latitude != 0.0 || s.stopLocation.longitude != 0.0,
        )
        .toList();
  }

  String _buildHtml() {
    final points = _validStops.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      final isStart = i == 0;
      final isEnd = i == _validStops.length - 1;
      final label = isStart
          ? 'S'
          : isEnd
          ? 'F'
          : '$i';
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
  .stop-marker.start { background: #F0C11D; color: #1a3b70; }
  .stop-marker.end { background: #EF6C4A; color: #fff; }
  
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
<script>
  const points = $pointsJson;
  const map = L.map('map', { zoomControl: false, attributionControl: true });

  L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; OSM &copy; CARTO',
    subdomains: 'abcd',
    maxZoom: 20
  }).addTo(map);

  const latlngs = [];
  points.forEach(p => {
    const cls = p.isStart ? 'stop-marker start' : (p.isEnd ? 'stop-marker end' : 'stop-marker');
    const icon = L.divIcon({
      className: '',
      html: '<div class="' + cls + '">' + p.label + '</div>',
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

  async function fetchWalkingSegment(lat1, lng1, lat2, lng2) {
    try {
      const url = 'https://router.project-osrm.org/route/v1/foot/'
        + lng1 + ',' + lat1 + ';' + lng2 + ',' + lat2
        + '?overview=full&geometries=geojson';
      const res = await fetch(url);
      const data = await res.json();
      if (data.code === 'Ok' && data.routes && data.routes[0]) {
        return data.routes[0].geometry.coordinates.map(c => [c[1], c[0]]);
      }
    } catch (_) {}
    return [[lat1, lng1], [lat2, lng2]];
  }

  async function drawRoutes() {
    for (let i = 0; i < points.length - 1; i++) {
      const p1 = points[i];
      const p2 = points[i + 1];
      const coords = await fetchWalkingSegment(p1.lat, p1.lng, p2.lat, p2.lng);
      L.polyline(coords, {
        color: '#1a3b70',
        weight: 4,
        opacity: 0.85,
        lineCap: 'round',
        lineJoin: 'round'
      }).addTo(map);
    }
  }

  if (latlngs.length > 1) { drawRoutes(); }

  // Live Location
  let userLatLng = null;
  let userMarker = null;
  let userCircle = null;

  function updateUserMarker(latlng, accuracy) {
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
    if (_validStops.isEmpty) return;
    final maps = await MapLauncher.installedMaps;
    if (maps.isEmpty) {
      if (!mounted) return;
      toast(context, "No map app", "No maps app is installed on this device");
      return;
    }

    final origin = _validStops.first;
    final destination = _validStops.last;
    final waypoints = _validStops.length > 2
        ? _validStops
              .sublist(1, _validStops.length - 1)
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
              "Route Map",
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
          body: _validStops.isEmpty
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
                      bottom: 3.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                              child: text_widget(
                                "${_validStops.length - 2} stop${_validStops.length == 1 ? '' : 's'} • dashed line shows stop sequence (golf-cart paths inside clubs)",
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
                              padding: EdgeInsets.all(2.5.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF6C4A),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                RemixIcons.external_link_line,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
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
