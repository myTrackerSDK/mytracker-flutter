package com.my.tracker

import android.app.Activity
import android.app.Application
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

class MyTrackerSDKPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private var contextRef: WeakReference<Context>? = null
    private var activityRef: WeakReference<Activity>? = null

    private var myTrackerChannel: MethodChannel? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)
        myTrackerChannel = methodChannel

        contextRef = WeakReference(flutterPluginBinding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        myTrackerChannel?.setMethodCallHandler(null)
        myTrackerChannel = null
        contextRef = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityRef = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() = Unit

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = Unit

    override fun onDetachedFromActivity() {
        activityRef = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val value: Any? = when (call.method) {
            INIT_METHOD -> init(call)
            FLUSH_METHOD -> MyTracker.flush()
			GET_INSTANCE_ID -> contextRef?.get()?.let { MyTracker.getInstanceId(it) }
            TRACK_EVENT_METHOD -> MyTracker.trackEvent(call.argument(TRACK_EVENT_NAME)!!, call.argument(TRACK_EVENT_PARAMS))
            TRACK_LOGIN_METHOD -> MyTracker.trackLoginEvent(call.argument(TRACK_USERID)!!, call.argument(TRACK_VKCONNECTID), call.argument(TRACK_EVENT_PARAMS))
            TRACK_REGISTRATION_METHOD -> MyTracker.trackRegistrationEvent(call.argument(TRACK_USERID)!!, call.argument(TRACK_VKCONNECTID), call.argument(TRACK_EVENT_PARAMS))
            IS_DEBUG_MODE_METHOD -> MyTracker.isDebugMode()
            SET_DEBUG_MODE_METHOD -> MyTracker.setDebugMode(call.argument(VALUE)!!)
            GET_ID_METHOD -> MyTracker.getTrackerConfig().id
            GET_BUFFERING_PERIOD_METHOD -> MyTracker.getTrackerConfig().bufferingPeriod
            SET_BUFFERING_PERIOD_METHOD -> MyTracker.getTrackerConfig().bufferingPeriod = call.argument(VALUE)!!
            GET_FORCING_PERIOD_METHOD -> MyTracker.getTrackerConfig().forcingPeriod
            SET_FORCING_PERIOD_METHOD -> MyTracker.getTrackerConfig().forcingPeriod = call.argument(VALUE)!!
            GET_LAUNCH_TIMEOUT_METHOD -> MyTracker.getTrackerConfig().launchTimeout
            SET_LAUNCH_TIMEOUT_METHOD -> MyTracker.getTrackerConfig().launchTimeout = call.argument(VALUE)!!
            SET_PROXY_HOST_METHOD -> MyTracker.getTrackerConfig().setProxyHost(call.argument(VALUE)).let { }
            IS_TRACKING_ENVIRONMENT_ENABLED -> MyTracker.getTrackerConfig().isTrackingEnvironmentEnabled
            SET_TRACKING_ENVIRONMENT_ENABLED -> MyTracker.getTrackerConfig().isTrackingEnvironmentEnabled = call.argument(VALUE)!!
            IS_TRACKING_LAUNCH_ENABLED -> MyTracker.getTrackerConfig().isTrackingLaunchEnabled
            SET_TRACKING_LAUNCH_ENABLED -> MyTracker.getTrackerConfig().isTrackingLaunchEnabled = call.argument(VALUE)!!
            IS_TRACKING_LOCATION_ENABLED -> MyTracker.getTrackerConfig().isTrackingLocationEnabled
            SET_TRACKING_LOCATION_ENABLED -> MyTracker.getTrackerConfig().isTrackingLocationEnabled = call.argument(VALUE)!!
            SET_AGE -> MyTracker.getTrackerParams().age = call.argument(VALUE) ?: -1
            GET_AGE -> MyTracker.getTrackerParams().age.takeIf { it != -1 }
            SET_GENDER -> MyTracker.getTrackerParams().gender = call.argument<Int>(VALUE)!! - 1
            GET_GENDER -> MyTracker.getTrackerParams().gender + 1
            SET_LANG -> MyTracker.getTrackerParams().lang = call.argument(VALUE)
            GET_LANG -> MyTracker.getTrackerParams().lang
            SET_CUSTOM_USER_IDS -> MyTracker.getTrackerParams().customUserIds = call.argument<List<String>>(VALUE)?.toTypedArray()
            GET_CUSTOM_USER_IDS -> MyTracker.getTrackerParams().customUserIds?.toList()
            SET_EMAILS -> MyTracker.getTrackerParams().emails = call.argument<List<String>>(VALUE)?.toTypedArray()
            GET_EMAILS -> MyTracker.getTrackerParams().emails?.toList()
            SET_PHONES -> MyTracker.getTrackerParams().phones = call.argument<List<String>>(VALUE)?.toTypedArray()
            GET_PHONES -> MyTracker.getTrackerParams().phones?.toList()

            else -> {
                result.notImplemented()
                return
            }
        }

        result.success(if (value is Unit) null else value)
    }

    private fun init(call: MethodCall) {
        contextRef?.get()?.also { MyTracker.initTracker(call.argument(INIT_PARAM_ID)!!, it as Application) }

        activityRef?.get()?.also { MyTracker.trackLaunchManually(it) }
    }

    companion object {
        const val CHANNEL_NAME = "_mytracker_api_channel"

        const val INIT_METHOD = "init"
        const val INIT_PARAM_ID = "id"

        const val FLUSH_METHOD = "flush"

		const val GET_INSTANCE_ID = "getInstanceId"

        const val TRACK_EVENT_METHOD = "trackEvent"
        const val TRACK_EVENT_NAME = "name"
        const val TRACK_EVENT_PARAMS = "eventParams"

        const val TRACK_LOGIN_METHOD = "trackLoginEvent"
        const val TRACK_USERID = "userId"
		const val TRACK_VKCONNECTID = "vkConnectId"

        const val TRACK_REGISTRATION_METHOD = "trackRegistrationEvent"

        const val IS_DEBUG_MODE_METHOD = "isDebugMode"

        const val SET_DEBUG_MODE_METHOD = "setDebugMode"

        const val GET_ID_METHOD = "getId"

        const val VALUE = "value"

        const val GET_BUFFERING_PERIOD_METHOD = "getBufferingPeriod"

        const val SET_BUFFERING_PERIOD_METHOD = "setBufferingPeriod"

        const val GET_FORCING_PERIOD_METHOD = "getForcingPeriod"

        const val SET_FORCING_PERIOD_METHOD = "setForcingPeriod"

        const val GET_LAUNCH_TIMEOUT_METHOD = "getLaunchTimeout"

        const val SET_LAUNCH_TIMEOUT_METHOD = "setLaunchTimeout"

        const val SET_PROXY_HOST_METHOD = "setProxyHost"

        const val SET_TRACKING_ENVIRONMENT_ENABLED = "setTrackingEnvironmentEnabled"
        const val IS_TRACKING_ENVIRONMENT_ENABLED = "isTrackingEnvironmentEnabled"

        const val SET_TRACKING_LAUNCH_ENABLED = "setTrackingLaunchEnabled"
        const val IS_TRACKING_LAUNCH_ENABLED = "isTrackingLaunchEnabled"

        const val SET_TRACKING_LOCATION_ENABLED = "setTrackingLocationEnabled"
        const val IS_TRACKING_LOCATION_ENABLED = "isTrackingLocationEnabled"

        const val GET_AGE = "getAge"
        const val SET_AGE = "setAge"

        const val GET_GENDER = "getGender"
        const val SET_GENDER = "setGender"

        const val GET_LANG = "getLang"
        const val SET_LANG = "setLang"

        const val GET_CUSTOM_USER_IDS = "getCustomUserIds"
        const val SET_CUSTOM_USER_IDS = "setCustomUserIds"

        const val GET_EMAILS = "getEmails"
        const val SET_EMAILS = "setEmails"

        const val GET_PHONES = "getPhones"
        const val SET_PHONES = "setPhones"
    }
}
