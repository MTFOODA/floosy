package com.example.floosy

import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.os.Handler
import android.os.Looper
import android.provider.Telephony
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * MainActivity with a lightweight SMS platform channel.
 *
 * The Dart side (SmsInboxService) calls `queryInbox` to read the device SMS
 * inbox through the public Telephony.Sms content provider. READ_SMS is a
 * dangerous permission: the native side re-verifies it before every query
 * and fails with PERMISSION_DENIED instead of crashing. No SMS body is
 * logged here — only counts (privacy requirement).
 *
 * Requirement: the automatic 5-second scan must never block the platform
 * (UI) thread, so the cursor loop runs on a single background worker and
 * the channel reply is posted back on the main looper.
 */
class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "FloosySMS"
        private const val CHANNEL_NAME = "floosy/sms"
    }

    private val smsExecutor: ExecutorService = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasPermissions" -> result.success(hasSmsPermissions())
                    "queryInbox" -> {
                        val maxCount = call.argument<Int>("maxCount") ?: 200
                        // Optional detection-range window (SMS Detection Range
                        // feature). Both are inclusive epoch-millisecond
                        // bounds; null = unbounded in that direction.
                        val sinceMs =
                            (call.argument<Any>("sinceDateMs") as? Number)?.toLong()
                        val untilMs =
                            (call.argument<Any>("untilDateMs") as? Number)?.toLong()
                        smsExecutor.execute {
                            queryInbox(maxCount, result, sinceMs, untilMs)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasSmsPermissions(): Boolean =
        ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) ==
            PackageManager.PERMISSION_GRANTED

    private fun queryInbox(
        maxCount: Int,
        result: MethodChannel.Result,
        sinceMs: Long?,
        untilMs: Long?,
    ) {
        if (!hasSmsPermissions()) {
            Log.w(TAG, "SMS_QUERY aborted: READ_SMS not granted")
            mainHandler.post {
                result.error("PERMISSION_DENIED", "READ_SMS permission is not granted", null)
            }
            return
        }
        val messages = ArrayList<Map<String, Any?>>()
        try {
            Log.d(
                TAG,
                "SMS_QUERY start (max=$maxCount"
                    + (if (sinceMs != null) ", since=$sinceMs" else "")
                    + (if (untilMs != null) ", until=$untilMs" else "")
                    + ")"
            )
            val projection = arrayOf(
                Telephony.Sms.ADDRESS,
                Telephony.Sms.BODY,
                Telephony.Sms.DATE,
            )
            // Detection-window filter (SMS Detection Range feature). Both
            // bounds are inclusive epoch-milliseconds. ORDER BY DATE DESC so
            // the newest messages arrive first; the Dart side still enforces
            // the count cap.
            val selection: String?
            val selectionArgs: Array<String>?
            if (sinceMs != null || untilMs != null) {
                val parts = mutableListOf<String>()
                if (sinceMs != null) parts.add("${Telephony.Sms.DATE} >= ?")
                if (untilMs != null) parts.add("${Telephony.Sms.DATE} <= ?")
                selection = parts.joinToString(" AND ")
                selectionArgs = buildList {
                    if (sinceMs != null) add(sinceMs.toString())
                    if (untilMs != null) add(untilMs.toString())
                }.toTypedArray()
            } else {
                selection = null
                selectionArgs = null
            }
            val cursor: Cursor? = contentResolver.query(
                Telephony.Sms.CONTENT_URI,
                projection,
                selection,
                selectionArgs,
                "${Telephony.Sms.DATE} DESC",
            )
            cursor?.use { c ->
                while (c.moveToNext() && messages.size < maxCount) {
                    val sender = c.getString(0) ?: ""
                    val body = c.getString(1) ?: ""
                    val date = c.getLong(2)
                    messages.add(
                        mapOf(
                            "sender" to sender,
                            "body" to body,
                            "date" to date,
                        )
                    )
                }
            }
            Log.d(TAG, "SMS_QUERY done count=${messages.size}")
            mainHandler.post { result.success(messages) }
        } catch (e: Exception) {
            Log.e(TAG, "SMS_QUERY failed", e)
            mainHandler.post { result.error("QUERY_FAILED", e.message, null) }
        }
    }
}
