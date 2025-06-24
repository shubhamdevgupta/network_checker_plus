import Flutter
import UIKit
import SystemConfiguration

public class NetworkCheckerPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "network_checker_plus", binaryMessenger: registrar.messenger())
    let instance = NetworkCheckerPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getConnectionType":
      result(getConnectionType())
    case "hasInternet":
      result(hasInternet())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getConnectionType() -> String {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    let reachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }

    var flags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachability!, &flags)

    if flags.contains(.reachable) {
      if flags.contains(.isWWAN) {
        return "mobile"
      }
      return "wifi"
    }

    return "none"
  }

  private func hasInternet() -> Bool {
    guard let reachability = SCNetworkReachabilityCreateWithName(nil, "google.com") else {
      return false
    }
    var flags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachability, &flags)
    return flags.contains(.reachable)
  }
}
