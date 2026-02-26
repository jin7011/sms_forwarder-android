package com.jaden.sms_forwarder

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.KeyEvent
import android.window.OnBackInvokedCallback
import android.window.OnBackInvokedDispatcher
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jaden.sms_forwarder/back_button"
    private val MMS_SERVICE_CHANNEL = "com.jaden.sms_forwarder/mms_service"
    private var methodChannel: MethodChannel? = null
    private var mmsServiceChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // MMS EventChannel - MMS 수신 이벤트를 Flutter로 전달
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, MmsEventChannel.CHANNEL_NAME)
            .setStreamHandler(MmsEventChannel.streamHandler)

        // MMS Service MethodChannel - Flutter에서 서비스 시작/중지 제어
        mmsServiceChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MMS_SERVICE_CHANNEL)
        mmsServiceChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    startMmsObserverService()
                    result.success(true)
                }
                "stopService" -> {
                    stopMmsObserverService()
                    result.success(true)
                }
                "getPendingMms" -> {
                    val pending = PendingMmsStore.consumeAll()
                    result.success(pending)
                }
                else -> result.notImplemented()
            }
        }

        if (Build.VERSION.SDK_INT >= 33) {
            onBackInvokedDispatcher.registerOnBackInvokedCallback(
                OnBackInvokedDispatcher.PRIORITY_DEFAULT,
                object : OnBackInvokedCallback {
                    override fun onBackInvoked() {
                        handleBackPressed()
                    }
                }
            )
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK && Build.VERSION.SDK_INT < 33) {
            handleBackPressed()
            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun startMmsObserverService() {
        val intent = Intent(this, MmsObserverService::class.java)
        startForegroundService(intent)
    }

    private fun stopMmsObserverService() {
        val intent = Intent(this, MmsObserverService::class.java)
        stopService(intent)
    }

    private fun handleBackPressed() {
        methodChannel?.invokeMethod("onBackPressed", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                val handled = result as? Boolean ?: false
                if (!handled) {
                    finish()
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                finish()
            }

            override fun notImplemented() {
                finish()
            }
        })
    }
}
