#
# Be sure to run `pod lib lint VRGSoftSwiftIOSKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

#
# Be sure to run `pod lib lint VRGSoftSwiftIOSKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    #root
        s.name      = 'VRGSoftSwiftIOSKit'
        s.version   = '2.0.0'
        s.summary   = 'VRGSoftSwiftIOSKit descriptions'
        s.license  = 'MIT'
        s.swift_version = '5.0'
        s.homepage  = 'https://vrgsoft.net/'
        s.authors   = {'semenag01' => 'semenag01@meta.ua'}
        s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
        s.source    = { :git => 'https://github.com/VRGsoftUA/VRGSoftSwiftIOSKit.git', :branch => 'master', :tag => '2.0.0' }

    #platform
        s.platform = :ios
        s.ios.deployment_target = '9.0'

    #build settings
        s.requires_arc = true

    #file patterns

        s.resources    = 'VRGSoftSwiftIOSKit/Resources/VRGSoftSwiftIOSKit.bundle'

        s.frameworks   = 'QuartzCore'
        s.frameworks   = 'CoreData'

        s.source_files = 'VRGSoftSwiftIOSKit/Core/**/*.swift'

        s.dependency 'Alamofire', '~> 4.8'
end
