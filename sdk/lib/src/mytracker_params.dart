import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _apiChannel = MethodChannel('_mytracker_api_channel');

/// Possible values of the user's gender.
enum MyTrackerGender { UNSPECIFIED, UNKNOWN, MALE, FEMALE }

/// Class for specifying additional tracking parameters
final class MyTrackerParams {
  /// Returns age of the current user.
  Future<int?> getAge() =>
      _apiChannel.invokeMethod("getAge").then((value) => value);

  /// Sets age [age] for the current user.
  Future<MyTrackerParams> setAge(int? age) =>
      _apiChannel.invokeMethod("setAge", {"value": age}).then((value) => this);

  /// Returns gender of the current user.
  /// Possible values are defined in [MyTrackerGender]
  Future<MyTrackerGender> getGender() => _apiChannel
      .invokeMethod("getGender")
      .then((value) => MyTrackerGender.values[value]);

  /// Sets gender of the current user [gender].
  /// Possible values are defined in [MyTrackerGender]
  ///
  /// ```dart
  /// MyTracker.trackerParams.setGender(MyTrackerGender.FEMALE)
  /// ```
  Future<MyTrackerParams> setGender(MyTrackerGender gender) => _apiChannel
      .invokeMethod("setGender", {"value": gender.index}).then((value) => this);

  /// Returns current language. The value can differ from the
  /// current language of the system.
  Future<String?> getLang() =>
      _apiChannel.invokeMethod("getLang").then((value) => value);

  /// Sets current language [lang]. You could use this method to
  /// override the system value of the language.
  Future<MyTrackerParams> setLang(String? lang) => _apiChannel
      .invokeMethod("setLang", {"value": lang}).then((value) => this);

  /// Returns identifiers of the current user.
  Future<List<String>?> getCustomUserIds() => _apiChannel
      .invokeMethod("getCustomUserIds")
      .then((value) => value == null ? null : List.from(value));

  /// Sets the array of  identifiers of the current user [customUserIds].
  Future<MyTrackerParams> setCustomUserIds(List<String>? customUserIds) =>
      _apiChannel.invokeMethod(
          "setCustomUserIds", {"value": customUserIds}).then((value) => this);

  /// Returns tracked emails of the current user, previously set in [setEmails]
  Future<List<String>?> getEmails() => _apiChannel
      .invokeMethod("getEmails")
      .then((value) => value == null ? null : List.from(value));

  /// Sets list of emails [emails] of the current user.
  Future<MyTrackerParams> setEmails(List<String>? emails) => _apiChannel
      .invokeMethod("setEmails", {"value": emails}).then((value) => this);

  /// Returns tracked phones of the current user, previously set in [setPhones]
  Future<List<String>?> getPhones() => _apiChannel
      .invokeMethod("getPhones")
      .then((value) => value == null ? null : List.from(value));

  /// Sets list of phone numbers [phones] of the current user.
  Future<MyTrackerParams> setPhones(List<String>? phones) => _apiChannel
      .invokeMethod("setPhones", {"value": phones}).then((value) => this);

  /// Sets custom parameter. Android only.
  /// [key] String key of the parameter.
  /// [key] String value of the parameter.
  Future<MyTrackerParams> setCustomParam(String key, String value) =>
      _apiChannel.invokeMethod(
          "setCustomParam", {"key": key, "value": value}).then((value) => this);

  /// Returns value for custom parameter by the key. Android only.
  /// [key] String key of the parameter.
  Future<String?> getCustomParam(String key) => _apiChannel
      .invokeMethod("getCustomParam", {"key": key}).then((value) => value);
}
