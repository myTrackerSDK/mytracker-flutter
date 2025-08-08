import 'dart:async';

import 'package:flutter/services.dart';

import 'mytracker_config.dart';
import 'mytracker_params.dart';

const MethodChannel _apiChannel = MethodChannel('_mytracker_api_channel');

const _ON_RECEIVE_ATTRIBUTION_METHOD = "onReceiveAttribution";

MyTrackerAttributionListener? _attributionListener = null;

mixin MyTrackerAttributionListener {
  void onReceiveAttribution(String deeplink);
}

/// Main facade to access MyTracker API
final class MyTracker {
  MyTracker._internal();

  static void _createHandler() {
    _apiChannel.setMethodCallHandler((call) {
      switch (call.method) {
        case _ON_RECEIVE_ATTRIBUTION_METHOD:
          if (_attributionListener != null) {
            _attributionListener
                ?.onReceiveAttribution(call.arguments.toString());
          }
          break;
      }
      return Future(() => null);
    });
  }

  /// Returns the instance of MyTrackerConfig
  ///
  /// NOTE: it's recommended to configure myTracker before call [MyTracker.init(id)]
  static late final MyTrackerConfig trackerConfig = MyTrackerConfig();

  /// Returns the instance of MyTrackerParams
  static late final MyTrackerParams trackerParams = MyTrackerParams();

  /// Returns the attribute whether the tracker prints debug information.
  static Future<bool> isDebugMode() =>
      _apiChannel.invokeMethod("isDebugMode").then((value) => value);

  /// Enables or disable printing debug information.  If [debugMode] true,
  /// the tracker prints debug information to LogCat.
  static Future setDebugMode(bool debugMode) =>
      _apiChannel.invokeMethod("setDebugMode", {"value": debugMode});

  /// Performs initialization of tracker.
  ///
  /// NOTE: this method should be called right after
  /// setup tracker configuration. [id] identifier of your application.
  static Future init(String id) {
    _createHandler();
    return _apiChannel.invokeMethod("init", {"id": id});
  }

  /// Force sends all saved events to the server.
  static Future flush() => _apiChannel.invokeMethod("flush");

  /// Tracks user defined event with custom name and optional key-value
  /// parameters. [name] is user defined event name. Max length is 255
  /// symbols. Additional key-value [eventParams] params can be added. Max
  /// length for key or value is 255 symbols.
  static Future trackEvent(String name, Map<String, String>? eventParams) =>
      _apiChannel.invokeMethod(
          "trackEvent", {"name": name, "eventParams": eventParams});

  /// Tracks invite event.
  /// [eventParams] params can be added.
  /// Max length for key or value is 255 symbols.
  static Future trackInviteEvent(Map<String, String>? eventParams) =>
      _apiChannel
          .invokeMethod("trackInviteEvent", {"eventParams": eventParams});

  /// Tracks level achieving event.
  /// [level] is number of achieved level.
  /// [eventParams] params can be added.
  static Future trackLevelEvent(int level, Map<String, String>? eventParams) =>
      _apiChannel.invokeMethod(
          "trackLevelEvent", {"level": level, "eventParams": eventParams});

  /// Tracks user login event. Call the method right after user successfully
  /// authorized in the app and got an unique identifier. [userId] Unique
  /// user identifier. [vkConnectId] Optional identifier from VK Connect.
  /// Additional key-value [eventParams] params can be added.
  /// Max length for key or value is 255 symbols.
  static Future trackLoginEvent(String userId, String? vkConnectId,
          Map<String, String>? eventParams) =>
      _apiChannel.invokeMethod("trackLoginEvent", {
        "userId": userId,
        "vkConnectId": vkConnectId,
        "eventParams": eventParams
      });

  /// Tracks user registration event. Call the method right after user
  /// successfully authorized in the app and got an unique identifier
  /// [userId] Unique user identifier. [vkConnectId] Optional identifier from VK Connect.
  /// Additional key-value [eventParams] params can be added.
  /// Max length for key or value is 255 symbols.
  static Future trackRegistrationEvent(String userId, String? vkConnectId,
          Map<String, String>? eventParams) =>
      _apiChannel.invokeMethod("trackRegistrationEvent", {
        "userId": userId,
        "vkConnectId": vkConnectId,
        "eventParams": eventParams
      });

  /// Return current instance id of tracker.
  static Future<String?> getInstanceId() =>
      _apiChannel.invokeMethod("getInstanceId").then((value) => value);

  /// The method for processing deeplink to application.
  /// Returns deeplink string or null if it hasn't been found.
  /// [uri] Deeplink.
  static Future<String?> handleDeeplink(String uri) =>
      _apiChannel.invokeMethod("handleDeeplink", {"uri": uri});

  /// Sets the attribution listener.
  /// [listener] The object which implemented MyTrackerAttributionListener mixin.
  static void setAttributionListener(MyTrackerAttributionListener? listener) {
    _apiChannel.invokeMethod("setAttributionListener");
    _attributionListener = listener;
  }
}
