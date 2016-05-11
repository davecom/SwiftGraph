Pod::Spec.new do |s|
  s.name             = 'SwiftGraph'
  s.version          = '1.0.6'
  s.license          = 'MIT'
  s.summary          = 'A Graph Data Structure in Pure Swift'
  s.homepage         = 'https://github.com/davecom/SwiftGraph'
  s.social_media_url = 'https://twitter.com/davekopec'
  s.authors          = { 'David Kopec' => 'david@oaksnow.com' }
  s.source           = { :git => 'https://github.com/davecom/SwiftGraph.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
end
