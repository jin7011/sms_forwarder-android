package com.jaden.sms_forwarder

import android.util.Log
import io.flutter.plugin.common.EventChannel

/**
 * Flutter EventChannel을 통해 MMS 이벤트를 전달하는 싱글톤
 * Logcat 필터: "MMS" 로 검색
 */
object MmsEventChannel {
    private const val TAG = "MMS"
    const val CHANNEL_NAME = "com.jaden.sms_forwarder/mms_events"

    private var eventSink: EventChannel.EventSink? = null

    val streamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
            Log.i(TAG, "[EventChannel] onListen - Flutter 리스너 연결됨 (포그라운드 이벤트 수신 가능)")
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
            Log.w(TAG, "[EventChannel] onCancel - Flutter 리스너 해제됨 (이후 MMS는 PendingStore에 저장)")
        }
    }

    /**
     * MMS 이벤트를 Flutter로 전송
     * Foreground Service (MmsObserverService)에서 호출됨
     */
    fun sendMmsEvent(data: Map<String, String>) {
        val sender = data["sender"] ?: "?"
        val bodyPreview = (data["body"] ?: "").take(50)

        val sink = eventSink
        if (sink != null) {
            sink.success(data)
            Log.i(TAG, "[EventChannel] Flutter로 MMS 전달 성공 - 발신자=$sender, 내용=\"$bodyPreview\"")
        } else {
            Log.w(TAG, "[EventChannel] EventSink null - Flutter 미연결 상태. PendingStore에 저장 - 발신자=$sender")
            PendingMmsStore.save(data)
        }
    }
}
