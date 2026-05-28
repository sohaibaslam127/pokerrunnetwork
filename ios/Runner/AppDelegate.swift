import UIKit
import Flutter
import GoogleMaps
import MapKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var routingChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCnUqH6cLCs3mjzRLLbPQYcPIoePD299Ps")
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      routingChannel = FlutterMethodChannel(
        name: "apple_maps_routing",
        binaryMessenger: controller.binaryMessenger
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
    }

    return result
  }

  private func getWalkingRoute(
    lat1: Double, lng1: Double,
    lat2: Double, lng2: Double,
    result: @escaping FlutterResult
  ) {
    let req = MKDirections.Request()
    req.source = MKMapItem(placemark: MKPlacemark(
      coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: lng1)
    ))
    req.destination = MKMapItem(placemark: MKPlacemark(
      coordinate: CLLocationCoordinate2D(latitude: lat2, longitude: lng2)
    ))
    req.transportType = .walking

    MKDirections(request: req).calculate { response, error in
      if error != nil {
        result([[lat1, lng1], [lat2, lng2]])
        return
      }
      guard let route = response?.routes.first else {
        result([[lat1, lng1], [lat2, lng2]])
        return
      }
      let n = route.polyline.pointCount
      var pts = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: n)
      route.polyline.getCoordinates(&pts, range: NSRange(location: 0, length: n))
      result(pts.map { [$0.latitude, $0.longitude] })
    }
  }
}
