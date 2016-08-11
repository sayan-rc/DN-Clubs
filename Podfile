# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'DN Clubs' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  pod 'Firebase/Messaging'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
  use_frameworks!

  # Pods for DN Clubs

  target 'DN ClubsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
