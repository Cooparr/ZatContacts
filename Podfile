# Uncomment the next line to define a global platform for your project
platform :ios, '14.1'

target 'ZatContacts' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for ZatContacts
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '8.3.0-beta'
  
  target 'ZatContactsTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'ZatContactsUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
      end
    end
  end
  
end
