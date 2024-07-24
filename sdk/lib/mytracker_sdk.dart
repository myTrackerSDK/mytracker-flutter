import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _apiChannel = MethodChannel('_mytracker_api_channel');

/// Possible values of the user's gender.
enum MyTrackerGender { UNSPECIFIED, UNKNOWN, MALE, FEMALE }

/// Main facade to access MyTracker API
class MyTracker {
  /// Returns the instance of MyTrackerConfig
  ///
  /// NOTE: it's recommended to configure myTracker before call [MyTracker.init(id)]
  static late final MyTrackerConfig trackerConfig = MyTrackerConfig._internal();

  /// Returns the instance of MyTrackerParams
  static late final MyTrackerParams trackerParams = MyTrackerParams._internal();

  /// Returns the attribute whether the tracker prints debug information.
  static Future<bool> isDebugMode() => _apiChannel.invokeMethod("isDebugMode").then((value) => value);

  /// Enables or disable printing debug information.  If [debugMode] true,
  /// the tracker prints debug information to LogCat.
  static Future setDebugMode(bool debugMode) => _apiChannel.invokeMethod("setDebugMode", {"value": debugMode});

  /// Performs initialization of tracker.
  ///
  /// NOTE: this method should be called right after
  /// setup tracker configuration. [id] identifier of your application.
  static Future init(String id) => _apiChannel.invokeMethod("init", {"id": id});

  /// Force sends all saved events to the server.
  static Future flush() => _apiChannel.invokeMethod("flush");

  /// Tracks user defined event with custom name and optional key-value
  /// parameters. [name] is user defined event name. Max length is 255
  /// symbols. Additional key-value [eventParams] params can be added. Max
  /// length for key or value is 255 symbols.
  static Future trackEvent(String name, Map<String, String>? eventParams) => _apiChannel.invokeMethod("trackEvent", {"name": name, "eventParams": eventParams});

  /// Track user login event. Call the method right after user successfully
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

  /// Track user registration event. Call the method right after user
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

  MyTracker._internal();
}

/// Class for configuring myTracker
class MyTrackerConfig {
  MyTrackerConfig._internal();

  /// Returns identifier that was provided in [MyTracker.init(id)].
  Future<String> getId() => _apiChannel.invokeMethod("getId").then((value) => value);

  /// Returns buffering period. During this period every tracked event is
  /// stored in local storage.
  ///
  /// The value is in range [1 - 86400].
  /// Default value is 900 seconds.
  Future<int> getBufferingPeriod() => _apiChannel.invokeMethod("getBufferingPeriod").then((value) => value);

  /// Sets the buffering period [bufferingPeriodSec] in seconds.  The value
  /// should be in range [1 - 86400]. Otherwise it will be rejected.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  /// call.
  Future<MyTrackerConfig> setBufferingPeriod(int bufferingPeriodSec) => _apiChannel.invokeMethod("setBufferingPeriod", {"value": bufferingPeriodSec}).then((value) => this);

  /// Returns forcing period in seconds. During this period every tracked
  /// event leads to flushing tracker. The start of the period is install
  /// or update of application.
  ///
  /// The value is in range [0 - 432000].
  /// Default value is 0. It means, that forcing period is disabled by default.
  Future<int> getForcingPeriod() => _apiChannel.invokeMethod("getForcingPeriod").then((value) => value);

  /// Sets the forcing period [forcingPeriodSec] in seconds. The value should
  /// be in range [0 - 432000]. Otherwise it will be  rejected.
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setForcingPeriod(int forcingPeriodSec) => _apiChannel.invokeMethod("setForcingPeriod", {"value": forcingPeriodSec}).then((value) => this);

  /// Returns launch timeout in in seconds. During this period
  /// start of the application after it close won't be considered as new launch.
  ///
  /// The value is in range [30 - 7200].
  /// Default value is 30.
  Future<int> getLaunchTimeout() => _apiChannel.invokeMethod("getLaunchTimeout").then((value) => value);

  /// Sets the launch timeout [seconds] in seconds.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setLaunchTimeout(int seconds) => _apiChannel.invokeMethod("setLaunchTimeout", {"value": seconds}).then((value) => this);

  /// Sets the host [proxyHost] to which all requests will be sent.
  ///
  /// The value provided in parameter will be additionally processed:
  /// - HTTPS scheme could be added if necessary
  /// - Query and Fragment parts will be deleted
  /// - the protocol version will be added
  ///
  /// To reset proxy host to default call the method with null parameter.
  ///
  /// NOTE: it's mandatory to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setProxyHost(String? proxyHost) => _apiChannel.invokeMethod("setProxyHost", {"value": proxyHost}).then((value) => this);

  /// Returns tracking environment state. Enabled state means that
  /// information about Wi-Fi and mobile networks will be collected.
  ///
  /// NOTE: this information are collected while sending request
  /// to the server. The impact to the battery is minimal.
  Future<bool> isTrackingEnvironmentEnabled() => _apiChannel.invokeMethod("isTrackingEnvironmentEnabled").then((value) => value);

  /// Enables or disables collecting environment information.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setTrackingEnvironmentEnabled(bool trackingEnvironmentEnabled) =>
      _apiChannel.invokeMethod("setTrackingEnvironmentEnabled", {"value": trackingEnvironmentEnabled}).then((value) => this);

  /// Returns whether tracking application launches is enabled or not.
  Future<bool> isTrackingLaunchEnabled() => _apiChannel.invokeMethod("isTrackingLaunchEnabled").then((value) => value);

  /// Enables or disables tracking application launches.
  ///
  /// NOTE: it's mandatory to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setTrackingLaunchEnabled(bool trackingLaunchEnabled) =>
      _apiChannel.invokeMethod("setTrackingLaunchEnabled", {"value": trackingLaunchEnabled}).then((value) => this);

  /// Returns whether collecting current location is enabled or not.
  ///
  /// NOTE: this information are collected while sending request
  /// to the server. The impact to the battery is minimal.
  Future<bool> isTrackingLocationEnabled() => _apiChannel.invokeMethod("isTrackingLocationEnabled").then((value) => value);

  /// Enables or disables collecting information about current location.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setTrackingLocationEnabled(bool trackingLocationEnabled) =>
      _apiChannel.invokeMethod("setTrackingLocationEnabled", {"value": trackingLocationEnabled}).then((value) => this);
}

/// Class for specifying additional tracking parameters
class MyTrackerParams {
  MyTrackerParams._internal();

  /// Returns age of the current user.
  Future<int?> getAge() => _apiChannel.invokeMethod("getAge").then((value) => value);

  /// Sets age [age] for the current user.
  Future<MyTrackerParams> setAge(int? age) => _apiChannel.invokeMethod("setAge", {"value": age}).then((value) => this);

  /// Returns gender of the current user.
  /// Possible values are defined in [MyTrackerGender]
  Future<MyTrackerGender> getGender() => _apiChannel.invokeMethod("getGender").then((value) => MyTrackerGender.values[value]);

  /// Sets gender of the current user [gender].
  /// Possible values are defined in [MyTrackerGender]
  ///
  /// ```dart
  /// MyTracker.trackerParams.setGender(MyTrackerGender.FEMALE)
  /// ```
  Future<MyTrackerParams> setGender(MyTrackerGender gender) => _apiChannel.invokeMethod("setGender", {"value": gender.index}).then((value) => this);

  /// Returns current language. The value can differ from the
  /// current language of the system.
  Future<String?> getLang() => _apiChannel.invokeMethod("getLang").then((value) => value);

  /// Sets current language [lang]. You could use this method to
  /// override the system value of the language.
  Future<MyTrackerParams> setLang(String? lang) => _apiChannel.invokeMethod("setLang", {"value": lang}).then((value) => this);

  /// Returns identifiers of the current user.
  Future<List<String>?> getCustomUserIds() => _apiChannel.invokeMethod("getCustomUserIds").then((value) => value == null ? null : List.from(value));

  /// Sets the array of  identifiers of the current user [customUserIds].
  Future<MyTrackerParams> setCustomUserIds(List<String>? customUserIds) => _apiChannel.invokeMethod("setCustomUserIds", {"value": customUserIds}).then((value) => this);

  /// Returns tracked emails of the current user, previously set in [setEmails]
  Future<List<String>?> getEmails() => _apiChannel.invokeMethod("getEmails").then((value) => value == null ? null : List.from(value));

  /// Sets list of emails [emails] of the current user.
  Future<MyTrackerParams> setEmails(List<String>? emails) => _apiChannel.invokeMethod("setEmails", {"value": emails}).then((value) => this);

  /// Returns tracked phones of the current user, previously set in [setPhones]
  Future<List<String>?> getPhones() => _apiChannel.invokeMethod("getPhones").then((value) => value == null ? null : List.from(value));

  /// Sets list of phone numbers [phones] of the current user.
  Future<MyTrackerParams> setPhones(List<String>? phones) => _apiChannel.invokeMethod("setPhones", {"value": phones}).then((value) => this);
}
