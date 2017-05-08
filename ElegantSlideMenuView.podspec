#
#  Be sure to run `pod spec lint ElegantSlideMenuView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "ElegantSlideMenuView"
  s.version      = "1.0.9"
  s.summary      = "A very easy to integrate the horizontal navigation menu."
  s.homepage     = "https://github.com/MichleMin/ElegantSlideMenuView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "MichleMin" => "286888980@qq.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/MichleMin/ElegantSlideMenuView.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

end
