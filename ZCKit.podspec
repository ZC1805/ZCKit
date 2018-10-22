
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
  s.frameworks   = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  s.xcconfig     = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)" }

  s.subspec 'Inherit' do |ss|
    ss.source_files = "ZCKit/Inherit/*.{h,m}"
    ss.xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Inherit" }
    ss.frameworks = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  end
  s.subspec 'Extend' do |ss|
    ss.source_files = "ZCKit/Extend/*.{h,m}"
    ss.xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/../Additional" }
    ss.frameworks = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  end
  s.subspec 'Swizzle' do |ss|
    ss.source_files = "ZCKit/Swizzle/*.{h,m}"
    ss.xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Swizzle" }
    ss.frameworks = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  end
  s.subspec 'Controls' do |ss|
    ss.source_files = "ZCKit/Controls/*.{h,m}"
    ss.xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/../Additional" }
    ss.frameworks = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  end
  s.subspec 'Category' do |ss|
    ss.source_files = "ZCKit/Category/*.{h,m}"
    ss.xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Category" }
    ss.frameworks = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  end
  s.subspec 'Additional' do |ss|
    ss.source_files = "ZCKit/Additional/*.{h,m}"
    ss.xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Additional" }
    ss.frameworks = "Foundation", "UIKit", "MessageUI", "CoreText", "Accelerate", "ImageIO", "QuartzCore"
  end

  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.frameworks = "UIKit"
  # s.library    = "iconv"
  # s.libraries  = "iconv", "xml2"
  # s.dependency "JSONKit", "~> 1.4"

end
