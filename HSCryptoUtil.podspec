#
# Be sure to run `pod lib lint HSCryptoUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSCryptoUtil'
  s.version          = '0.1.2'
  s.summary          = 'Support Crypto related functions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Crypto related function. such as AES-CFB8, AES256 etc"

  s.homepage         = 'https://github.com/frontmono/HSCryptUtil'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HarryKim' => 'hkim@titanplatform.us' }
  s.source           = { :git => 'https://github.com/frontmono/HSCryptUtil.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HSCryptoUtil/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HSCryptoUtil' => ['HSCryptoUtil/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
