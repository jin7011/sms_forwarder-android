package com.jaden.sms_forwarder

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Telephony
import android.util.Log
import java.io.BufferedReader
import java.io.InputStreamReader

class MmsObserverService : Service() {

    companion object {
        // Logcat 필터: "MMS" 로 검색하면 모든 MMS 관련 로그 확인 가능
        private const val TAG = "MMS"
        private const val CHANNEL_ID = "sms_forwarder_channel"
        private const val NOTIFICATION_ID = 1001
        // MMS 다운로드 완료 대기 시간 (기본 메시징 앱이 MMS를 저장할 시간)
        private const val MMS_READ_DELAY_MS = 3000L
        // 중복 방지: 같은 MMS ID를 무시할 시간
        private const val DEDUP_WINDOW_MS = 10000L
    }

    private var mmsObserver: MmsContentObserver? = null
    private val handler = Handler(Looper.getMainLooper())

    // 중복 방지용: 최근 처리한 MMS ID와 시간
    private val recentMmsIds = mutableMapOf<String, Long>()

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "[Service] onCreate - Foreground Service 생성 시작")
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, buildNotification())
        Log.i(TAG, "[Service] startForeground 완료 - 알림 표시됨")
        registerMmsObserver()
        Log.i(TAG, "[Service] 초기화 완료 - MMS 수신 대기 중")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "[Service] onStartCommand - flags=$flags, startId=$startId")
        return START_STICKY // 시스템이 서비스를 죽여도 재시작
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        unregisterMmsObserver()
        handler.removeCallbacksAndMessages(null)
        Log.w(TAG, "[Service] onDestroy - Foreground Service 종료됨")
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "SMS Forwarder",
            NotificationManager.IMPORTANCE_LOW // 소리/진동 없음
        ).apply {
            description = "SMS/MMS 포워딩 서비스 실행 중"
            setShowBadge(false)
        }
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
        Log.d(TAG, "[Service] 알림 채널 생성 완료")
    }

    private fun buildNotification(): Notification {
        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("SMS Forwarder")
            .setContentText("SMS/MMS 수신 대기 중")
            .setSmallIcon(android.R.drawable.ic_dialog_email)
            .setOngoing(true)
            .build()
    }

    private fun registerMmsObserver() {
        mmsObserver = MmsContentObserver(handler)
        contentResolver.registerContentObserver(
            Uri.parse("content://mms"),
            true, // 하위 URI 변경도 감지
            mmsObserver!!
        )
        Log.i(TAG, "[Observer] ContentObserver 등록 완료 - content://mms 감시 시작")
    }

    private fun unregisterMmsObserver() {
        mmsObserver?.let {
            contentResolver.unregisterContentObserver(it)
            Log.i(TAG, "[Observer] ContentObserver 해제 완료")
        }
        mmsObserver = null
    }

    /**
     * MMS DB 변경 감지 ContentObserver
     */
    private inner class MmsContentObserver(handler: Handler) : ContentObserver(handler) {
        override fun onChange(selfChange: Boolean, uri: Uri?) {
            super.onChange(selfChange, uri)
            Log.d(TAG, "[Observer] onChange 호출 - selfChange=$selfChange, uri=$uri")

            // 딜레이 후 읽기 - 기본 메시징 앱이 MMS를 완전히 저장할 시간 확보
            Log.d(TAG, "[Observer] ${MMS_READ_DELAY_MS}ms 딜레이 후 MMS 읽기 예약")
            handler.postDelayed({
                try {
                    readLatestMms()
                } catch (e: Exception) {
                    Log.e(TAG, "[Observer] MMS 읽기 중 예외 발생: ${e.message}", e)
                }
            }, MMS_READ_DELAY_MS)
        }
    }

    /**
     * 최신 MMS inbox 메시지를 읽어서 Flutter로 전달
     */
    private fun readLatestMms() {
        Log.d(TAG, "[Read] content://mms/inbox 쿼리 시작")

        val cursor = contentResolver.query(
            Uri.parse("content://mms/inbox"),
            arrayOf("_id", "date", "read"),
            null,
            null,
            "date DESC" // 최신순
        )

        if (cursor == null) {
            Log.e(TAG, "[Read] inbox 쿼리 실패 - cursor가 null")
            return
        }

        cursor.use {
            val count = it.count
            Log.d(TAG, "[Read] inbox 메시지 수: $count")

            if (!it.moveToFirst()) {
                Log.d(TAG, "[Read] inbox가 비어있음 - 처리할 MMS 없음")
                return
            }

            val idIndex = it.getColumnIndex("_id")
            if (idIndex < 0) {
                Log.e(TAG, "[Read] _id 컬럼을 찾을 수 없음")
                return
            }

            val mmsId = it.getString(idIndex)
            Log.d(TAG, "[Read] 최신 MMS ID: $mmsId")

            // 중복 방지
            val now = System.currentTimeMillis()
            cleanupOldDedup(now)
            if (recentMmsIds.containsKey(mmsId)) {
                Log.d(TAG, "[Dedup] 중복 MMS 무시 - ID=$mmsId (${DEDUP_WINDOW_MS}ms 이내 이미 처리)")
                return
            }
            recentMmsIds[mmsId] = now
            Log.d(TAG, "[Dedup] 새 MMS 등록 - ID=$mmsId (현재 추적 중: ${recentMmsIds.size}건)")

            // 텍스트 파트 읽기
            Log.d(TAG, "[Read] MMS $mmsId 텍스트 파트 읽기 시작")
            val textBody = readMmsTextPart(mmsId)
            if (textBody.isNullOrBlank()) {
                Log.w(TAG, "[Read] MMS $mmsId: 텍스트 없음 (이미지 전용 MMS이거나 아직 다운로드 미완료)")
                return
            }
            Log.i(TAG, "[Read] MMS $mmsId 텍스트 추출 성공 - 길이=${textBody.length}자, 미리보기=\"${textBody.take(80)}\"")

            // 발신자 읽기
            Log.d(TAG, "[Read] MMS $mmsId 발신자 정보 읽기")
            val sender = readMmsSender(mmsId) ?: "알 수 없음"
            Log.i(TAG, "[Read] MMS $mmsId 발신자: $sender")

            Log.i(TAG, "========== MMS 수신 완료 ==========")
            Log.i(TAG, "  ID: $mmsId")
            Log.i(TAG, "  발신자: $sender")
            Log.i(TAG, "  내용: ${textBody.take(100)}")
            Log.i(TAG, "  Flutter 전달 시도...")
            Log.i(TAG, "====================================")

            // Flutter로 전달
            MmsEventChannel.sendMmsEvent(mapOf(
                "sender" to sender,
                "body" to textBody
            ))
        }
    }

    /**
     * MMS의 text/plain 파트에서 텍스트 추출
     */
    private fun readMmsTextPart(mmsId: String): String? {
        val cursor = contentResolver.query(
            Uri.parse("content://mms/$mmsId/part"),
            arrayOf("_id", "ct", "text"),
            null,
            null,
            null
        )

        if (cursor == null) {
            Log.e(TAG, "[TextPart] MMS $mmsId part 쿼리 실패 - cursor가 null")
            return null
        }

        cursor.use {
            val partCount = it.count
            Log.d(TAG, "[TextPart] MMS $mmsId 파트 수: $partCount")

            var partIndex = 0
            while (it.moveToNext()) {
                val ctIndex = it.getColumnIndex("ct")
                if (ctIndex < 0) {
                    Log.d(TAG, "[TextPart] 파트[$partIndex]: ct 컬럼 없음 - 건너뜀")
                    partIndex++
                    continue
                }

                val contentType = it.getString(ctIndex) ?: "null"
                Log.d(TAG, "[TextPart] 파트[$partIndex]: contentType=$contentType")

                if (contentType != "text/plain") {
                    Log.d(TAG, "[TextPart] 파트[$partIndex]: text/plain 아님 - 건너뜀 ($contentType)")
                    partIndex++
                    continue
                }

                // text 컬럼에서 직접 읽기 시도
                val textIndex = it.getColumnIndex("text")
                if (textIndex >= 0) {
                    val text = it.getString(textIndex)
                    if (!text.isNullOrBlank()) {
                        Log.i(TAG, "[TextPart] 파트[$partIndex]: text 컬럼에서 직접 읽기 성공 (${text.length}자)")
                        return text
                    }
                    Log.d(TAG, "[TextPart] 파트[$partIndex]: text 컬럼이 null/empty - InputStream 시도")
                }

                // text 컬럼이 null이면 _data를 통해 InputStream으로 읽기
                val idIdx = it.getColumnIndex("_id")
                if (idIdx >= 0) {
                    val partId = it.getString(idIdx)
                    val partUri = Uri.parse("content://mms/part/$partId")
                    Log.d(TAG, "[TextPart] 파트[$partIndex]: InputStream으로 읽기 시도 - partId=$partId")
                    try {
                        contentResolver.openInputStream(partUri)?.use { inputStream ->
                            val reader = BufferedReader(InputStreamReader(inputStream, "UTF-8"))
                            val sb = StringBuilder()
                            var line: String?
                            while (reader.readLine().also { l -> line = l } != null) {
                                sb.append(line)
                            }
                            val result = sb.toString()
                            if (result.isNotBlank()) {
                                Log.i(TAG, "[TextPart] 파트[$partIndex]: InputStream 읽기 성공 (${result.length}자)")
                                return result
                            }
                            Log.d(TAG, "[TextPart] 파트[$partIndex]: InputStream 결과 비어있음")
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "[TextPart] 파트[$partIndex]: InputStream 읽기 실패 - partId=$partId, 에러=${e.message}", e)
                    }
                }
                partIndex++
            }
        }
        Log.w(TAG, "[TextPart] MMS $mmsId: text/plain 파트를 찾지 못함")
        return null
    }

    /**
     * MMS 발신자 번호 읽기 (addr 테이블에서 from 주소)
     */
    private fun readMmsSender(mmsId: String): String? {
        val cursor = contentResolver.query(
            Uri.parse("content://mms/$mmsId/addr"),
            arrayOf("address", "type"),
            null,
            null,
            null
        )

        if (cursor == null) {
            Log.e(TAG, "[Sender] MMS $mmsId addr 쿼리 실패 - cursor가 null")
            return null
        }

        cursor.use {
            Log.d(TAG, "[Sender] MMS $mmsId addr 레코드 수: ${it.count}")

            while (it.moveToNext()) {
                val typeIndex = it.getColumnIndex("type")
                if (typeIndex < 0) continue

                val type = it.getInt(typeIndex)
                val addrIndex = it.getColumnIndex("address")
                val address = if (addrIndex >= 0) it.getString(addrIndex) else null

                Log.d(TAG, "[Sender] addr 레코드: type=$type, address=$address")

                // type 137 = PduHeaders.FROM (발신자)
                if (type == 137) {
                    if (!address.isNullOrBlank() && address != "insert-address-token") {
                        Log.i(TAG, "[Sender] 발신자 확인: $address (type=137/FROM)")
                        return address
                    }
                    Log.d(TAG, "[Sender] type=137이지만 address가 유효하지 않음: '$address'")
                }
            }
        }
        Log.w(TAG, "[Sender] MMS $mmsId: 발신자를 찾지 못함")
        return null
    }

    /**
     * 오래된 중복 방지 엔트리 정리
     */
    private fun cleanupOldDedup(now: Long) {
        val expired = recentMmsIds.filter { now - it.value > DEDUP_WINDOW_MS }
        if (expired.isNotEmpty()) {
            expired.keys.forEach { recentMmsIds.remove(it) }
            Log.d(TAG, "[Dedup] 만료된 엔트리 ${expired.size}건 정리 (남은: ${recentMmsIds.size}건)")
        }
    }
}
