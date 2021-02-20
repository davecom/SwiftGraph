Pod::Spec.new do |s|
  s.name             = 'SwiftGraph'
  s.version          = '3.1'
  s.license          = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.summary          = 'A Graph Data Structure in Pure Swift'
  s.homepage         = 'https://github.com/davecom/SwiftGraph'
  s.social_media_url = 'https://twitter.com/davekopec'
  s.authors          = { 'David Kopec' => 'david@oaksnow.com' }
  s.source           = { :git => 'https://github.com/davecom/SwiftGraph.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'Sources/SwiftGraph/*.swift'
  s.requires_arc = true
  s.swift_versions = ['5.0', '5.1', '5.2', '5.3']
end
