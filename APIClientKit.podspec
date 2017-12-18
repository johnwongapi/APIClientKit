Pod::Spec.new do |s|
  s.name             = 'APIClientKit'
  s.version          = '0.1.1'
  s.summary          = 'Simple iOS API Client with Alamofire'

  s.homepage         = 'https://github.com/johnwongapi/APIClientKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'John' => 'johnwongapi@gmail.com' }

  s.ios.deployment_target = '8.0'
  s.source           = { :git => 'https://github.com/johnwongapi/APIClientKit.git', :tag => s.version.to_s }
  s.source_files  = "Source/*.{h,m,swift}", "Source/**/*.{h,m,swift}" , "Source/**/**/*.{h,m,swift}" , "Source/**/**/**/*.{h,m,swift}"
  s.dependency 'Alamofire', '~> 4.5'

end
