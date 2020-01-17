
Pod::Spec.new do |s|
  s.name         = "URLRouter"
  s.version      = "0.1.0"
  s.summary      = "Powerful & Efficient URL Routing for Swift"
  s.homepage     = "https://github.com/WessonWu/URLRouter"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "wuweixin" => "wessonwu94@gmail.com" }
  s.source       = { :git => "https://github.com/WessonWu/URLRouter.git", :tag => "#{s.version}" }
  s.requires_arc     = true
  s.swift_version    = "5.0"
  
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"

  s.subspec "Matcher" do |sp|
      sp.frameworks = "Foundation"
      sp.source_files = "Source/URLMatcher/**/*.swift"
  end
  
  s.subspec "Router" do |sp|
      sp.frameworks = "Foundation", "UIKit"
      sp.source_files = "Source/URLRouter/**/*.swift"
      sp.dependency "URLRouter/Matcher"
  end
  
  s.default_subspecs = ["Matcher", "Router"]
  
  # for test
  s.test_spec "Tests" do |test_spec|
    test_spec.source_files = "Tests/**/*"
    test_spec.dependency "URLRouter/Matcher"
    test_spec.dependency "URLRouter/Router"
  end

end
