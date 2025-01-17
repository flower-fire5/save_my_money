# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'save_my_money' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for save_my_money
  pod 'Masonry'
  pod 'JZNavigationExtension'
  pod 'ReactiveObjC'
  pod 'MJExtension'
  pod 'BRPickerView'
  pod 'YYText'
  pod 'YYImage'
  pod 'Realm'
  pod 'FSCalendar'
  pod 'MJRefresh', '3.1.15.7'
  pod 'MGSwipeTableCell', '1.6.8'
  pod 'LookinServer', :configurations => ['Debug']
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end
