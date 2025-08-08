Pod::Spec.new do |s|
  s.name                = 'mytracker_sdk'
  s.version             = '3.2.0'
  s.summary             = 'iOS SDK of myTracker analytics'
  s.description         = 'myTracker — free mobile analytics for iOS, Android and Windows platforms. Get connected to know everything about your apps, audience and advertising campaigns'
  s.homepage            = 'https://tracker.my.com'
  s.documentation_url   = 'https://tracker.my.com/docs/'
  s.license             = { :type => 'LGPL-3.0'}
  s.authors             = { 'My.com' => 'sdk_mytracker@corp.my.com' }

  s.platform            = :ios, '12.4'
  s.source              = { :path => '.' }
  s.ios.deployment_target = '12.4'

  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework    = true

  s.dependency          'Flutter'
  s.ios.dependency      'myTrackerSDK', '3.2.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
