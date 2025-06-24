package com.example.network_checker_plus


import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.net.InetAddress
import kotlin.concurrent.thread

class NetworkCheckerPlusPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "network_checker_plus")
    channel.setMethodCallHandler(this)
    context = binding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "getConnectionType" -> result.success(getConnectionType())
      "hasInternet" -> {
        thread {
          result.success(hasInternet())
        }
      }
      else -> result.notImplemented()
    }
  }

  private fun getConnectionType(): String {
    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    val network = cm.activeNetwork ?: return "none"
    val capabilities = cm.getNetworkCapabilities(network) ?: return "none"
    return when {
      capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
      capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "mobile"
      else -> "other"
    }
  }

  private fun hasInternet(): Boolean {
    return try {
      val address = InetAddress.getByName("google.com")
      !address.equals("")
    } catch (e: Exception) {
      false
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
