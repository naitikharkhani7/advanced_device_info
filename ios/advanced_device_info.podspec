Pod::Spec.new do |s|
  s.name             = 'advanced_device_info'
  s.version          = '0.0.2'
  s.summary          = 'A Flutter plugin for comprehensive Android and iOS device information.'
  s.description      = <<-DESC
A Flutter plugin for comprehensive Android and iOS device information.
                       DESC
  s.homepage         = 'https://github.com/naitikharkhani7/advanced_device_info'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Naitik Harkhani' => 'naitikharkhani7@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'advanced_device_info/Sources/advanced_device_info/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = '5.0'
  s.resource_bundles = {'advanced_device_info_privacy' => ['advanced_device_info/Sources/advanced_device_info/PrivacyInfo.xcprivacy']}
end
