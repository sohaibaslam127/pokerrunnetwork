import Flutter
import MapKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  // Strong reference — without this the channel is deallocated and calls never arrive
  private var routingChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // registrar(_:) is the correct Swift bridging of the Obj-C registrar: method
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AppleMapsRouting") else {
      print("[AppleMapsRouting] Failed to get registrar — channel will not work")
      return
    }

    routingChannel = FlutterMethodChannel(
      name: "apple_maps_routing",
      binaryMessenger: registrar.messenger()
    )
    routingChannel?.setMethodCallHandler { [weak self] call, result in
      guard call.method == "getWalkingRoute",
            let args = call.arguments as? [String: Double],
            let lat1 = args["lat1"], let lng1 = args["lng1"],
            let lat2 = args["lat2"], let lng2 = args["lng2"]
      else {
        result(FlutterError(code: "BAD_ARGS", message: "Missing coordinates", details: nil))
        return
      }
      self?.getWalkingRoute(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2, result: result)
    }
    print("[AppleMapsRouting] Channel registered successfully")
  }

  private func getWalkingRoute(
    lat1: Double, lng1: Double,
    lat2: Double, lng2: Double,
    result: @escaping FlutterResult
  ) {
    print("[AppleMapsRouting] Requesting route (\(lat1),\(lng1)) -> (\(lat2),\(lng2))")
    let req = MKDirections.Request()
    req.source = MKMapItem(placemark: MKPlacemark(
      coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: lng1)
    ))
    req.destination = MKMapItem(placemark: MKPlacemark(
      coordinate: CLLocationCoordinate2D(latitude: lat2, longitude: lng2)
    ))
    req.transportType = .walking

    MKDirections(request: req).calculate { response, error in
      if let error = error {
        print("[AppleMapsRouting] MKDirections error: \(error.localizedDescription)")
        result([[lat1, lng1], [lat2, lng2]])
        return
      }
      guard let route = response?.routes.first else {
        print("[AppleMapsRouting] No routes in response")
        result([[lat1, lng1], [lat2, lng2]])
        return
      }
      let n = route.polyline.pointCount
      var pts = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: n)
      route.polyline.getCoordinates(&pts, range: NSRange(location: 0, length: n))
      let coords = pts.map { [$0.latitude, $0.longitude] }
      print("[AppleMapsRouting] Route OK — \(coords.count) points")
      result(coords)
    }
  }
}
