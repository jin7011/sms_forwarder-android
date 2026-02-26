package com.jaden.sms_forwarder

import android.util.Log

/**
 * 백그라운드에서 수신된 MMS를 임시 저장
 * Flutter EventChannel이 연결되지 않은 상태(앱이 백그라운드)에서
 * 수신된 MMS 텍스트를 저장해두고, 앱이 포그라운드로 올 때 전달
 *
 * Logcat 필터: "MMS" 로 검색
 */
object PendingMmsStore {
    private const val TAG = "MMS"
    private val pendingMessages = mutableListOf<Map<String, String>>()

    fun save(data: Map<String, String>) {
        synchronized(pendingMessages) {
            pendingMessages.add(data)
            val sender = data["sender"] ?: "?"
            Log.i(TAG, "[PendingStore] MMS 저장 - 발신자=$sender (대기열: ${pendingMessages.size}건)")
        }
    }

    fun consumeAll(): List<Map<String, String>> {
        synchronized(pendingMessages) {
            val copy = pendingMessages.toList()
            pendingMessages.clear()
            if (copy.isNotEmpty()) {
                Log.i(TAG, "[PendingStore] 대기 MMS ${copy.size}건 소비 (Flutter로 전달 예정)")
            } else {
                Log.d(TAG, "[PendingStore] 대기 MMS 없음")
            }
            return copy
        }
    }

    fun isEmpty(): Boolean {
        synchronized(pendingMessages) {
            return pendingMessages.isEmpty()
        }
    }
}
