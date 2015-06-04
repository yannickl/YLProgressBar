Pod::Spec.new do |s|
  s.name             = 'YLProgressBar'
  s.version          = '3.6.1'
  s.platform         = :ios, '5.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'UIProgressView replacement with an highly and fully customizable animated progress bar in pure Core Graphics'
  s.homepage         = 'https://github.com/yannickl/YLProgressBar'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.social_media_url = "https://twitter.com/yannickloriot"
  s.source           = { :git => 'https://github.com/yannickl/YLProgressBar.git',
                         :tag => s.version.to_s }
  s.source_files     = ['YLProgressBar/YLProgressBar.{h,m}']
  s.frameworks       = 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc     = true
end
