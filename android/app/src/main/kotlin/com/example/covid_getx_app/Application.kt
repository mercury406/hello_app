package com.example.covid_getx_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent.getActivity
import android.content.Context
import android.os.Build
import android.provider.Settings.Global.getString
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundExecutor
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin


class Application : FlutterApplication(), PluginRegistrantCallback {

    override
    fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
        FlutterFirebaseMessagingBackgroundExecutor.setPluginRegistrant(this)
    }

    override
    fun registerWith(registry: PluginRegistry) {
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"))
        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        FlutterFirebaseMessagingPlugin.registerWith(registry.registrarFor("plugins.flutter.io/firebase_messaging"))
    }

    private fun createChannel(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel
            val name = getString(R.string.default_notification_channel_id)
            val channel = NotificationChannel(name, "default", NotificationManager.IMPORTANCE_HIGH)

            val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

}