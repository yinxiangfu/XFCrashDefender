Pod::Spec.new do |s|
    s.name         = 'XFCrashDefender'
    s.version      = '1.0.0'
    s.summary      = '防止调用不存在的方法导致App崩溃'
    s.homepage     = 'https://github.com/yinxiangfu/XFCrashDefender'
    s.license      = 'MIT'
    s.authors      = {'yinxiangfu' => '2014759954@qq.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/yinxiangfu/XFCrashDefender.git', :tag => s.version}
    s.source_files = 'XFCrashDefender/**/*.{h,m}'
    s.requires_arc = true
end
