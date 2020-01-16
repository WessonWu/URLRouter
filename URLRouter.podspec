
Pod::Spec.new do |s|

  s.name         = "URLRouter"
  s.version      = "0.1.0"
  s.summary      = "URLRouter..."

  s.description  = <<-DESC
                      URLRouter ...
                    DESC

  s.homepage     = "https://github.com/WessonWu/URLRouter"

  s.license      = "GPL"

  s.platform = :ios, '9.0'

  s.author       = { "wuweixin" => "wessonwu94@gmail.com" }

  s.source       = { :git => "https://github.com/WessonWu/URLRouter.git", :tag => "#{s.version}" }

  s.source_files = 'Source/**/*'
  s.frameworks = 'Foundation','UIKit'

end
