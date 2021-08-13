# myTracker Flutter SDK

![Platforms][platforms-svg]
[![License][license-svg]][license-link]

* [Общая информация](#общая-информация)
* [Инициализация](#инициализация)
    * [Доступные для настройки параметры](#доступные-для-настройки-параметры)
        * [MyTrackerConfig](#mytrackerconfig)
        * [MyTrackerParams](#mytrackerparams)
    * [Включение/выключение режима отладки](#включение/выключение-режима-отладки)
* [События](#события)

## Общая информация

myTracker — Мультиплатформенная система аналитики и атрибуции на базе технологий Mail.ru Group.

### Минимальные требования

#### Android
* Android api level 14 (Android 4.0)
* Разрешение `android.permission.INTERNET`
* Разрешение `android.permission.ACCESS_NETWORK_STATE`

Обязательные зависимости, которые будет добавлены автоматически:
* [Google Play Services](https://developers.google.com/android/guides/setup) (модуль com.google.android.gms:play-services-ads-identifier)
* [Google Play Install Referrer](https://developer.android.com/google/play/installreferrer) (модуль com.android.installreferrer:installreferrer)

#### iOS
* Минимальная поддерживаемая версия iOS - 9.0
* xCode версия 12.4 или выше

В случае, если необходимо получение информации об IDFA/IDFV на iOS 14+, то необходимо получение разрешения от пользователя.  
Для решения, возможно использовать [App Tracking Transparency Plugin](https://pub.dev/packages/app_tracking_transparency). Или реализовать запрос разрешений самостоятельно.

### Данные о местоположении

Если необходим сбор данных о местоположении, то добавление разрешений на доступ к локации и запрос этих разрешений также является обязательным.  
Для решения данной задачи можно воспользоваться [Location Permission Plugin](https://pub.dev/packages/location_permissions). Или реализовать запрос разрешений самостоятельно.

### Приложения для Huawei App Store
Если вы делаете сборку приложения для [Huawei App Store](https://appstore.huawei.com/), то обязательно наличие в проекте подключенной библиотеки
[Huawei Media Services](https://developer.huawei.com/consumer/en/service/hms/catalog/pps_document.html?page=hmssdk_huaweipps_devprepare_download_SDK)
(модуль com.huawei.hms:hms-ads-identifier), для того, чтобы myTracker мог получить
[OAID](https://developer.huawei.com/consumer/en/service/hms/catalog/pps_document.html?page=hmssdk_huaweipps_introduction).

## Подключение

Скачайте SDK, добавьте его в ваш проект по некоторому пути `PATH_TO_SDK` и укажите его в качестве зависимости в `pubspec.yaml` вашего приложения:
```yaml
dependencies:
  ...
  mytracker_sdk:
    path: PATH_TO_SDK
  ...
```

## Инициализация

При инициализации трекера необходимо указать ваш appId.
При необходимости до инициализации, можно выполнить дополнительную конфигурацию трекера и параметров.  
Активность приложения (запуски, сессии) отслеживается автоматически.

```dart
// При необходимости настраиваем параметры
MyTrackerParams trackerParams = await MyTracker.getTrackerParams();
MyTrackerParams trackerConfig = await MyTracker.getTrackerConfig();

// ...
// Настройка параметров трекера
// ...

// Инициализируем экземпляр
await MyTracker.initTracker(SDK_KEY);
```


### Доступные для настройки параметры

Конфигурацию трекера можно произвести через экземпляр класса `MyTrackerConfig`, доступный через метод `MyTracker.getTrackerConfig()`.  
Параметры трекера можно настроить через экземпляр класса `MyTrackerParams`, который доступен через метод `MyTracker.getTrackerParams()`.

#### MyTrackerConfig
Экземпляр данного класса отвечает за конфигурацию трекера и предоставляет следующие методы.

```dart
Future<MyTrackerConfig> setTrackingLaunchEnabled(boolean trackingLaunchEnabled)
```
Отслеживание запусков приложения. По умолчанию true.

```dart
Future<MyTrackerConfig> setLaunchTimeout(int seconds)
```
Интервал в секундах, в течение которого не будет засчитываться новый запуск и прерываться сессия при сворачивании приложения.  
По умолчанию 30 секунд. Можно установить значение в диапазоне 30-7200 секунд.

```dart
Future<MyTrackerConfig> setBufferingPeriod(int seconds)
```
Интервал в секундах, в течение которого события будут накапливаться на устройстве перед отправкой на сервер.  
По умолчанию 900 секунд. Можно установить значение в диапазоне 1-86400 секунд.

```dart
Future<MyTrackerConfig> setForcingPeriod(int seconds)
```
Интервал в секундах после установки или обновления приложения, в течение которого события будут незамедлительно отправляться на сервер.  
По умолчанию 0 секунд (незамедлительная отправка выключена). Можно установить значение в диапазоне 0-432000 секунд (5 суток).

```dart
Future<MyTrackerConfig> setAutotrackingPurchaseEnabled(boolean autotrackingPurchaseEnabled)
```
Автоматическое отслеживание покупок в приложении.  
По умолчанию true.

```dart
Future<MyTrackerConfig> setTrackingLocationEnabled(boolean trackingLocationEnabled)
```
Отслеживание местоположения.  
По умолчанию true.

```dart
Future<MyTrackerConfig> setRegion(MyTrackerRegion region)
```
Установка региона сервера приёма данных.   
Доступные значения:
* MyTrackerRegion.EU - Европа.
* MyTrackerRegion.RU - РФ.

```dart
Future<MyTrackerConfig> setProxyHost(@Nullable String proxyHost)
```
Установка прокси-хоста сервера приёма данных.

#### MyTrackerParams
Экземпляр данного класса предназначен для настройки пользовательских параметров.

Пользовательские параметры могут быть установлены в любой момент работы приложения.

```dart 
Future setUserInfo() async
{
    MyTrackerParams trackerParams = await MyTracker.getTrackerParams();
     
    // Устанавливаем пол
    await trackerParams.setAge(22);
    // Устанавливаем возраст
    await trackerParams.setGender(MyTrackerGender.FEMALE);
    // Устанавливаем айди
    trackerParams.setCustomUserIds(["user_id_0", "user_id_1"]);
    //Устанавливаем адреса электронной почты
    trackerParams.setEmails(["address1@example.com", "address2@example.com"]);
    //Устанавливаем номера телефонаов
    trackerParams.setPhones(["84953332211", "84953332212", "84953332213"]);
}
```

### Включение/выключение режима отладки
Включение/выключение режима отладки производится через статические методы класса MyTracker.

```dart
Future setDebugMode(boolean debugMode)
```
Включение/выключение режима отладки.  
По умолчанию false.

## Трекинг событий
События можно отправлять через статические методы класса MyTracker.  
Доступны следующие методы для трекинга различных типов событий:

```dart 
Future trackLoginEvent(String userId, Map<String, String>? eventParams)
```
Событие логина.  
Обязательный параметр userId задаёт идентификатор пользователя.  
Дополнительный параметр eventParams позволяет задать произвольные параметры ключ-значение для события.  
Максимальная длина ключа и значения - 255 символов.

```dart  
Future trackRegistrationEvent(String userId, Map<String, String>? eventParams)
```
Событие регистрации.  
Обязательный параметр userId задаёт идентификатор пользователя.  
Дополнительный параметр eventParams позволяет задать произвольные параметры ключ-значение для события.  
Максимальная длина ключа и значения - 255 символов.

```dart 
Future trackEvent(String name, Map<String, String>? eventParams)
```
Произвольное событие с заданным именем.  
Дополнительный параметр eventParams позволяет задать произвольные параметры ключ-значение для события.  
Максимальная длина ключа и значения - 255 символов.  
Например:
```dart 
MyTracker.trackEvent("name", {"key_0": "value_0", "key_1": "value_1"});
```

```dart 
Future flush()
```
Принудительная отправка всех событий и сброс таймера отправки.

[license-svg]: https://img.shields.io/badge/license-LGPL-lightgrey.svg
[license-link]: https://github.com/myTrackerSDK/mytracker-flutter/blob/master/LICENSE
[platforms-svg]: https://img.shields.io/badge/platform-Flutter-lightgrey.svg
