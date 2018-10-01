
Pod::Spec.new do |s|
  s.name             = 'WQUtil'
  s.version          = '0.0.1'
  s.summary          = '存放类别和网络请求的封装库'
  s.homepage         = 'https://github.com/wq1570375769/WQUtil'
  s.license          = 'MIT'
  s.author           = { 'wq1570375769' => '1570375769@qq.com' }
  s.source           = { :git => 'https://github.com/wq1570375769/WQUtil.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'WQUtil/Classes/*.{h,m}'

  s.dependency 'AFNetworking'
  s.dependency 'YYModel'


end
