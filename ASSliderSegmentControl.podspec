#
# Be sure to run `pod lib lint ASSliderSegmentControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ASSliderSegmentControl"
  s.version          = "0.5.5"
  s.summary          = "Custom slider segment control."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "The customized segment control allow to make switching between segment with sliding effect"

  s.homepage         = "https://github.com/svetlanama/ASSliderSegmentControl"
  # s.screenshots     = "https://github.com/svetlanama/ASSliderSegmentControl/demo/demo.png", "https://github.com/svetlanama/ASSliderSegmentControl/demo/animation12.gif"
  s.license          = 'MIT'
  s.author           = { "Svitlana Moiseyenko" => "alexandrovna.sveta@gmail.com", "Alexander Vasileyko" => "vasileyko.alex@gmail.com" }
  s.source           = { :git => "https://github.com/svetlanama/ASSliderSegmentControl.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/s_moiseyenko'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
#s.resource_bundles = {
# 'ASSliderSegmentControl' => ['Pod/Assets/*.png']
# }


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
