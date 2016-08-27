use_frameworks!
def shared_pods
    pod 'ObjectMapper'
    pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'swift2.3'
    pod 'AlamofireObjectMapper'
end
target 'Poggy' do
  platform :ios, '10.0'
  shared_pods
  pod 'OAuthSwift', :git => 'https://github.com/OAuthSwift/OAuthSwift.git', :branch => 'swift2.3'
  pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git', :branch => 'swift2.3'
  pod 'SDWebImage'
  pod 'BuddyBuildSDK'
end
target 'Poggy WatchKit Extension' do
  platform :watchos, '3.0'
  shared_pods
end
