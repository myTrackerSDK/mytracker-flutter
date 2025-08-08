import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _apiChannel = MethodChannel('_mytracker_api_channel');

/// Class for configuring myTracker
final class MyTrackerConfig {

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