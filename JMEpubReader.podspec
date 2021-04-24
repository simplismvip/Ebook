#
# Be sure to run `pod lib lint JMEpubReader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JMEpubReader'
  s.version          = '0.1.0'
  s.summary          = 'A short description of JMEpubReader.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
电子书解析阅读器
                       DESC

  s.homepage         = 'https://github.com/simplismvip/JMEpubReader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'simplismvip' => 'tonyzhao60@gmail.com' }
  s.source           = { :git => 'https://github.com/simplismvip/JMEpubReader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.public_header_files = 'Pod/Classes/Config/*.h'
  s.source_files = [
    'Classes/*.{h,swift}',
    'Classes/Comps/*.swift',
    'Classes/Extension/*.swift',
    'Classes/Config/*.{swift,h}',
    'Classes/Home/*.swift',
    'Classes/CoreParser/*.{swift,h,m}',
    'Classes/EpubParser/*.{swift}',
    'Classes/MenView/*.{swift}'
  ]
  
  s.resources = [
    'Classes/Source/*.{bundle,html,md}',
    'Classes/Source/Fonts/**/*.{otf,ttf}'
  ]
  
  # s.resource_bundles = {
  #   'JMEpubReader' => ['JMEpubReader/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'EPUBKit'
  s.dependency 'FMDB'
  s.dependency 'SnapKit'
  s.dependency 'ZJMKit'
#  s.dependency 'RxSwift'
#  s.dependency 'RxCocoa'
  s.dependency 'HandyJSON'
#  s.dependency 'BSText'
  s.dependency 'YYText'
  
end
