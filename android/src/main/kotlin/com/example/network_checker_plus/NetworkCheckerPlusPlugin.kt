package com.example.network_checker_plus

import android.content.Context
import android.net.*
import android.net.wifi.WifiManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.net.HttpURLConnection
import java.net.URL

/** NetworkCheckerPlusPlugin */
class NetworkCheckerPlusPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context
    private var connectivityManager: ConnectivityManager? = null
    private var eventSink: EventChannel.EventSink? = null
    private var networkCallback: ConnectivityManager.NetworkCallback? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "network_checker_plus")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "network_checker_plus/connection")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        connectivityManager?.unregisterNetworkCallback(networkCallback!!)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "isConnected" -> result.success(isConnected())
            "getConnectionType" -> result.success(getConnectionType())
            "getNetworkSpeed" -> result.success(getNetworkSpeed())
            "getSignalStrength" -> result.success(getSignalStrength())
            else -> result.notImplemented()
        }
    }

    private fun isConnected(): Boolean {
        val network = connectivityManager?.activeNetwork
        val capabilities = connectivityManager?.getNetworkCapabilities(network)
        return capabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
    }

    private fun getConnectionType(): String {
        val network = connectivityManager?.activeNetwork ?: return "none"
        val capabilities = connectivityManager?.getNetworkCapabilities(network) ?: return "none"

        return when {
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "mobile"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
            else -> "unknown"
        }
    }

    private fun getNetworkSpeed(): String {
        return try {
            val start = System.currentTimeMillis()
            val url = URL("https://www.google.com")
            val conn = url.openConnection() as HttpURLConnection
            conn.connectTimeout = 1500
            conn.connect()
            val response = conn.responseCode
            conn.disconnect()
            val duration = System.currentTimeMillis() - start

            when {
                response != 200 -> "No Connection"
                duration < 100 -> "Excellent"
                duration < 300 -> "Good"
                duration < 600 -> "Moderate"
                else -> "Poor"
            }
        } catch (e: Exception) {
            "No Connection"
        }
    }

    private fun getSignalStrength(): Int {
        return try {
            val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val rssi = wifiManager.connectionInfo.rssi
            WifiManager.calculateSignalLevel(rssi, 5) // Range: 0 (weak) to 4 (strong)
        } catch (e: Exception) {
            -1
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events

        networkCallback = object : ConnectivityManager.NetworkCallback() {
          override fun onAvailable(network: Network) {
    android.os.Handler(android.os.Looper.getMainLooper()).post {
        eventSink?.success("connected")
    }
}

override fun onLost(network: Network) {
    android.os.Handler(android.os.Looper.getMainLooper()).post {
        eventSink?.success("disconnected")
    }
}

        }

        connectivityManager?.registerDefaultNetworkCallback(networkCallback!!)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        networkCallback?.let { connectivityManager?.unregisterNetworkCallback(it) }
    }
}
