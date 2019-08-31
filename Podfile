target 'Stakeout' do
  use_frameworks!
  
  pod 'TwitterKit', '3.4.2' # probably 3.2.2
#  pod 'TwitterCore', '<3.1.0' # probably 3.0.3

  pod 'Swifter', :git => 'https://github.com/mattdonnelly/Swifter.git', :tag => '2.1.0'
  pod 'AppCenter'
  pod 'AzureNotificationHubs-iOS'

  plugin 'cocoapods-keys', {
  :project => "Stakeout",
  :keys => [
    "TwitterConsumerKey",
    "TwitterConsumerSecret",
	"AppCenterAppSecret",
	"AzureHubName_Sandbox",
	"AzureHubListenAccess_Sandbox"
	
  ]}

  target 'StakeoutTests' do
    inherit! :search_paths
  end
  
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Stakeout/Pods-Stakeout-acknowledgements.plist', 'Stakeout/Other/Settings.bundle/Code-Acknowledgements.plist', :remove_destination => true)
    
    installer.aggregate_targets.each do |aggregate_target|
      aggregate_target.xcconfigs.each do |config_name, config_file|
        config_file.other_linker_flags[:frameworks].delete("TwitterCore")

        xcconfig_path = aggregate_target.xcconfig_path(config_name)
        config_file.save_as(xcconfig_path)
      end
    end
end
