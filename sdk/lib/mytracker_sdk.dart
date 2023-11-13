import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _apiCnannel = MethodChannel('_mytracker_api_channel');

/// Possible values of the region.
enum MyTrackerRegion { RU, EU }

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

  static late FutureCallback _attributionListener;

  /// Returns the attribute whether the tracker prints debug information.
  static Future<bool> isDebugMode() =>
      _apiCnannel.invokeMethod("isDebugMode").then((value) => value);

  /// Enables or disable printing debug information.  If [debugMode] true,
  /// the tracker prints debug information to LogCat.
  static Future setDebugMode(bool debugMode) =>
      _apiCnannel.invokeMethod("setDebugMode", {"value": debugMode});

  /// Performs initialization of tracker.
  ///
  /// NOTE: this method should be called right after
  /// setup tracker configuration. [id] identifier of your application.
  static Future init(String id) async {
    _apiCnannel.invokeMethod("init", {"id": id});

    _apiCnannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'getAttribution') {
        _attributionListener(call.arguments);
      }
    });
  }

  static Future getInstanceId() => _apiCnannel.invokeMethod('getInstanceId');

  static void setAttributionListener(FutureCallback listener) {
    _attributionListener = listener;
    _apiCnannel.invokeMethod('setAttributionListener');
  }

  /// Force sends all saved events to the server.
  static Future flush() => _apiCnannel.invokeMethod("flush");

  /// Tracks user defined event with custom name and optional key-value
  /// parameters. [name] is user defined event name. Max length is 255
  /// symbols. Additional key-value [eventParams] params can be added. Max
  /// length for key or value is 255 symbols.
  static Future trackEvent(String name, Map<String, String>? eventParams) =>
      _apiCnannel.invokeMethod(
          "trackEvent", {"name": name, "eventParams": eventParams});

  /// Track user login event. Call the method right after user successfully
  /// authorized in the app and got an unique identifier. [userId] Unique
  /// user identifier. Additional key-value [eventParams] params can be added.
  /// Max length for key or value is 255 symbols.
  static Future trackLoginEvent(
          String userId, Map<String, String>? eventParams) =>
      _apiCnannel.invokeMethod(
          "trackLoginEvent", {"userId": userId, "eventParams": eventParams});

  /// Track user registration event. Call the method right after user
  /// successfully authorized in the app and got an unique identifier
  /// [userId] Unique user identifier. Additional key-value [eventParams] params can be added.
  /// Max length for key or value is 255 symbols.
  static Future trackRegistrationEvent(
          String userId, Map<String, String>? eventParams) =>
      _apiCnannel.invokeMethod("trackRegistrationEvent",
          {"userId": userId, "eventParams": eventParams});

  MyTracker._internal();
}

/// Class for configuring myTracker
class MyTrackerConfig {
  MyTrackerConfig._internal();

  /// Returns identifier that was provided in [MyTracker.init(id)].
  Future<String> getId() =>
      _apiCnannel.invokeMethod("getId").then((value) => value);

  /// Returns buffering period. During this period every tracked event is
  /// stored in local storage.
  ///
  /// The value is in range [1 - 86400].
  /// Default value is 900 seconds.
  Future<int> getBufferingPeriod() =>
      _apiCnannel.invokeMethod("getBufferingPeriod").then((value) => value);

  /// Sets the buffering period [bufferingPeriodSec] in seconds.  The value
  /// should be in range [1 - 86400]. Otherwise it will be rejected.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  /// call.
  Future<MyTrackerConfig> setBufferingPeriod(int bufferingPeriodSec) =>
      _apiCnannel.invokeMethod("setBufferingPeriod",
          {"value": bufferingPeriodSec}).then((value) => this);

  /// Returns forcing period in seconds. During this period every tracked
  /// event leads to flushing tracker. The start of the period is install
  /// or update of application.
  ///
  /// The value is in range [0 - 432000].
  /// Default value is 0. It means, that forcing period is disabled by default.
  Future<int> getForcingPeriod() =>
      _apiCnannel.invokeMethod("getForcingPeriod").then((value) => value);

  /// Sets the forcing period [forcingPeriodSec] in seconds. The value should
  /// be in range [0 - 432000]. Otherwise it will be  rejected.
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setForcingPeriod(int forcingPeriodSec) => _apiCnannel
      .invokeMethod("setForcingPeriod", {"value": forcingPeriodSec}).then(
          (value) => this);

  /// Returns launch timeout in in seconds. During this period
  /// start of the application after it close wont't be considered as new launch.
  ///
  /// The value is in range [30 - 7200].
  /// Default value is 30.
  Future<int> getLaunchTimeout() =>
      _apiCnannel.invokeMethod("getLaunchTimeout").then((value) => value);

  /// Sets the launch timeout [seconds] in seconds.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setLaunchTimeout(int seconds) =>
      _apiCnannel.invokeMethod(
          "setLaunchTimeout", {"value": seconds}).then((value) => this);

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
  Future<MyTrackerConfig> setProxyHost(String? proxyHost) => _apiCnannel
      .invokeMethod("setProxyHost", {"value": proxyHost}).then((value) => this);

  /// Sets the region. [region] The value switch the proxy host to predefined
  /// values or reset it to default value.
  ///
  /// Possible values are defined in [MyTrackerRegion]
  ///
  /// NOTE: it's mandatory to call this method before [MyTracker.init(id)]
  ///
  /// For example, setting region to EU
  /// ```dart
  /// MyTracker.trackerConfig.setRegion(MyTrackerRegion.EU)
  /// MyTracker.init(id)
  /// ```
  Future<MyTrackerConfig> setRegion(MyTrackerRegion region) => _apiCnannel
      .invokeMethod("setRegion", {"value": region.index}).then((value) => this);

  /// Returns tracking environment state. Enabled state means that
  /// information about Wi-Fi and mobile networks will be collected.
  ///
  /// NOTE: this information are collected while sending request
  /// to the server. The impact to the battery is minimal.
  Future<bool> isTrackingEnvironmentEnabled() => _apiCnannel
      .invokeMethod("isTrackingEnvironmentEnabled")
      .then((value) => value);

  /// Enables or disables collecting environment information.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setTrackingEnvironmentEnabled(
          bool trackingEnvironmentEnabled) =>
      _apiCnannel.invokeMethod("setTrackingEnvironmentEnabled",
          {"value": trackingEnvironmentEnabled}).then((value) => this);

  /// Returns whether tracking application launches is enabled or not.
  Future<bool> isTrackingLaunchEnabled() => _apiCnannel
      .invokeMethod("isTrackingLaunchEnabled")
      .then((value) => value);

  /// Enables or disables tracking application launches.
  ///
  /// NOTE: it's mandatory to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setTrackingLaunchEnabled(
          bool trackingLaunchEnabled) =>
      _apiCnannel.invokeMethod("setTrackingLaunchEnabled",
          {"value": trackingLaunchEnabled}).then((value) => this);

  /// Returns whether collecting current location is enabled or not.
  ///
  /// NOTE: this information are collected while sending request
  /// to the server. The impact to the battery is minimal.
  Future<bool> isTrackingLocationEnabled() => _apiCnannel
      .invokeMethod("isTrackingLocationEnabled")
      .then((value) => value);

  /// Enables or disables collecting information about current location.
  ///
  /// NOTE: it's recommended to call this method before [MyTracker.init(id)]
  Future<MyTrackerConfig> setTrackingLocationEnabled(
          bool trackingLocationEnabled) =>
      _apiCnannel.invokeMethod("setTrackingLocationEnabled",
          {"value": trackingLocationEnabled}).then((value) => this);
}

/// Class for specifying additional tracking parameters
class MyTrackerParams {
  MyTrackerParams._internal();

  /// Returns age of the current user.
  Future<int?> getAge() =>
      _apiCnannel.invokeMethod("getAge").then((value) => value);

  /// Sets age [age] for the current user.
  Future<MyTrackerParams> setAge(int? age) =>
      _apiCnannel.invokeMethod("setAge", {"value": age}).then((value) => this);

  /// Returns gender of the current user.
  /// Possible values are defined in [MyTrackerGender]
  Future<MyTrackerGender> getGender() => _apiCnannel
      .invokeMethod("getGender")
      .then((value) => MyTrackerGender.values[value]);

  /// Sets gender of the current user [gender].
  /// Possible values are defined in [MyTrackerGender]
  ///
  /// ```dart
  /// MyTracker.trackerParams.setGender(MyTrackerGender.FEMALE)
  /// ```
  Future<MyTrackerParams> setGender(MyTrackerGender gender) => _apiCnannel
      .invokeMethod("setGender", {"value": gender.index}).then((value) => this);

  /// Returns current language. The value can differ from the
  /// current language of the system.
  Future<String?> getLang() =>
      _apiCnannel.invokeMethod("getLang").then((value) => value);

  /// Sets current language [lang]. You could use this method to
  /// override the system value of the language.
  Future<MyTrackerParams> setLang(String? lang) => _apiCnannel
      .invokeMethod("setLang", {"value": lang}).then((value) => this);

  /// Returns identifiers of the current user.
  Future<List<String>?> getCustomUserIds() => _apiCnannel
      .invokeMethod("getCustomUserIds")
      .then((value) => value == null ? null : List.from(value));

  /// Sets the array of  identifiers of the current user [customUserIds].
  Future<MyTrackerParams> setCustomUserIds(List<String>? customUserIds) =>
      _apiCnannel.invokeMethod(
          "setCustomUserIds", {"value": customUserIds}).then((value) => this);

  /// Returns tracked emails of the current user, previously set in [setEmails]
  Future<List<String>?> getEmails() => _apiCnannel
      .invokeMethod("getEmails")
      .then((value) => value == null ? null : List.from(value));

  /// Sets list of emails [emails] of the current user.
  Future<MyTrackerParams> setEmails(List<String>? emails) => _apiCnannel
      .invokeMethod("setEmails", {"value": emails}).then((value) => this);

  /// Returns tracked phones of the current user, previously set in [setPhones]
  Future<List<String>?> getPhones() => _apiCnannel
      .invokeMethod("getPhones")
      .then((value) => value == null ? null : List.from(value));

  /// Sets list of phone numpers [phones] of the current user.
  Future<MyTrackerParams> setPhones(List<String>? phones) => _apiCnannel
      .invokeMethod("setPhones", {"value": phones}).then((value) => this);
}

typedef FutureCallback = void Function(String atribution);
