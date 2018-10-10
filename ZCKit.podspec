
Pod::Spec.new do |s|

  s.name         = "ZCKit"
  s.version      = "0.0.1"
  s.summary      = "iOS ZCKit"
  s.homepage     = "https://github.com/ZhouClassmate/ZCKit"
  s.description  = <<-DESC
                        ZCKit is iOS common development component and keep up the update.
                   DESC

  s.license      = "MIT"
  s.author       = { "Mr.Zhou" => "961627191@qq.com" }

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/ZhouClassmate/ZCKit.git", :tag => "#{s.version}" }
  s.source_files = "ZCKit/*.{h,m}"
  s.resources    = "ZCKit/Resources/*.png"
  s.frameworks   = "Foundation", "UIKit"

  s.subspec 'Swizzle' do |ss|
    ss.source_files = "ZCKit/Swizzle/*.{h,m}"
  end
  s.subspec 'Controls' do |ss|
    ss.source_files = "ZCKit/Controls/*.{h,m}"
  end
  s.subspec 'Category' do |ss|
    ss.source_files = "ZCKit/Category/*.{h,m}"
  end
  s.subspec 'Additional' do |ss|
    ss.source_files = "ZCKit/Additional/*.{h,m}"
  end

  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework = "SomeFramework"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
