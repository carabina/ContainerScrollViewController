Pod::Spec.new do |s|
  s.name             = 'ContainerScrollViewController'
  s.version          = '0.1.3'
  s.summary          = 'A Swift class for embedding a view controller in a scroll view container view controller'

  s.description      = <<-DESC
ContainerScrollViewController embeds a view controller within a container scroll
view. The scroll view's content can then be manipulated within Interface Builder
separately, within an embedded view controller of arbitrary size.
                       DESC

  s.homepage         = 'https://github.com/milpitas/ContainerScrollViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'milpitas' => 'drew.olbrich@gmail.com' }
  s.source           = { :git => 'https://github.com/milpitas/ContainerScrollViewController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/drewolbrich'

  s.ios.deployment_target = '11.0'

  s.source_files = 'ContainerScrollViewController/**/*.swift'

  s.frameworks = 'UIKit'

  s.swift_version = '4.2'
end
