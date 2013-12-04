Pod::Spec.new do |s|
  s.name         = 'TSProgressCircle'
  s.version      = '0.1.1'
  s.summary      = 'Animatable circular progress indicator'
  s.license		 = 'MIT'
  s.author = {
    'Mark McFarlane' => 'mark@tacchistudios.com'
  }
  s.source = {
    :git => 'https://github.com/TacchiStudios/TSProgressCircle.git',
    :tag => '0.1.0'
  }
  s.source_files = 'Source/*.{h,m}'
  s.platform = :ios, '6.0'
  s.homepage = 'https://github.com/tacchistudios/TSProgressCircle'
end