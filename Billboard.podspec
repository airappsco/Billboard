#
# Be sure to run `pod lib lint AirPurchase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Billboard'
  s.version          = '1.1.1'
  s.summary          = 'Billboard is a module that enables the incorporation of advertisement highlights for applications created by independent developers'
  s.description      = 'Billboard is a module that enables the incorporation of advertisement highlights for applications created by independent developers. Its unique feature lies in its execution of ads without the use of tracking measures or unwanted cookies. This way, your user can still get annoyed by advertisements without the nasty bits, and therefore you get a free "Remove Ads" selling point for your premium tier.'

  s.homepage         = 'https://airapps.co'
  s.license          = { :type => 'AIR APPS CUSTOM', :file => 'LICENSE' }
  s.author           = { 'Ufuk Benlice' => 'ufuk.benlice@airapps.com' }
  s.source           = { :git => 'git@github.com:airappsco/Billboard.git', :tag => s.version }
  s.swift_versions = '5.0'
  s.ios.deployment_target = "12.0"
  s.source_files  = "Sources/Billboard/**/*.swift"

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
end
