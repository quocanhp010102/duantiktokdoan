# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'tiktokprojectmaxcode' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for tiktokprojectmaxcode
pod 'FirebaseAuth'
pod 'FirebaseStorage'
pod 'FirebaseDatabase'
pod 'FirebaseAnalytics'
pod 'FirebaseCore'
pod 'ProgressHUD'
pod 'SDWebImage'
end


post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
 if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 14.0
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
 end
end

end
