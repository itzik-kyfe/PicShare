# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PicShare' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PicShare
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'FirebaseUI/Storage'
pod 'Firebase/Database'
pod 'Firebase/Analytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      end
    end
  end
end
