#
# Be sure to run `pod lib lint Scheduler.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Disposable'
  s.version          = '1.0.5'
  s.summary          = 'Resource cleanup.'

  s.homepage         = 'https://github.com/GodL/Disposable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '547188371@qq.com' => '547188371@qq.com' }
  s.source           = { :git => 'https://github.com/GodL/Disposable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Disposable/Disposable/**.{swift,h}'
  
  s.swift_version = '5'
end
