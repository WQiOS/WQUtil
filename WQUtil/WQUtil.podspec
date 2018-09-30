
Pod::Spec.new do |s|
  s.name             = 'WQUtil'
  s.version          = '0.0.1'
  s.summary          = '存放类别和网络请求的封装库'
  s.homepage         = 'https://github.com/wq1570375769/WQUtil'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wq1570375769' => '1570375769@qq.com' }
  s.source           = { :git => 'https://github.com/wq1570375769/WQUtil.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.public_header_files = 'WQUtil/Classes/*.h'

  s.dependency 'AFNetworking'
  s.dependency 'YYModel'

  s.subspec 'Category' do |category|
    category.source_files = "WQUtil/Classes/Category/*.{h,m}"
  end

  s.subspec 'Networking' do |networking|
    networking.source_files = "WQUtil/Classes/Networking/*.{h,m}"
  end

end
