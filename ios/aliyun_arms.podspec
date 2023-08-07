#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aliyun_arms.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aliyun_arms'
  s.version          = '1.0.1'
  s.summary          = '阿里ARMS,应用实时检测'
  s.description      = <<-DESC
  阿里ARMS,应用实时检测
                       DESC
  s.homepage         = 'https://github.com/vsguji/aliyun_arms'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'vsguji_2012@sina.com' }
  s.source           = { :git => 'https://github.com/vsguji/aliyun_arms.git' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  #
  s.platform = :ios, '9.0'
  #
  s.frameworks = 'UIKit','Foundation'
  #
  s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  # 崩溃
  s.dependency 'AlicloudCrash','~> 1.2.0'
  # 性能
  s.dependency 'AlicloudAPM', '~> 1.0.0'
  # 远程日志
  s.dependency 'AlicloudTLog','~> 1.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
