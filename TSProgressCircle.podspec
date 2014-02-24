Pod::Spec.new do |s|
  s.name         = 'TSProgressCircle'
  s.version      = '0.1.2'
  s.summary      = 'Animatable circular progress indicator'
  s.license		 = 'MIT'
  s.author = {
    'Mark McFarlane' => 'mark@tacchistudios.com'
  }
  s.source = {
    :git => 'git://github.com/TacchiStudios/TSProgressCircle.git',
    :tag => '0.1.2'
  }
  s.source_files = 'Source/*.{h,m}'
  s.platform = :ios, '6.0'
  s.homepage = 'https://github.com/tacchistudios/TSProgressCircle'
  
  s.frameworks = 'QuartzCore'
end