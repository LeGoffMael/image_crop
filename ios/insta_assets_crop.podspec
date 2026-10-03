#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'insta_assets_crop'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin to crop image on iOS and Android.'
  s.description      = <<-DESC
A flutter plugin to crop image on iOS and Android.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'insta_assets_crop/Sources/insta_assets_crop/**/*.{h,m}'
  s.public_header_files = 'insta_assets_crop/Sources/insta_assets_crop/include/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '13.0'
end

