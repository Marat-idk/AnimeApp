# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AnimeApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AnimeApp

    # ObjectMapper
    pod 'ObjectMapper'

    # UI
    pod 'SnapKit'

    # network
    pod 'netfox'

  target 'AnimeAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AnimeAppUITests' do
    # Pods for testing
  end
end

post_install do |installer|   
      installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end

    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
