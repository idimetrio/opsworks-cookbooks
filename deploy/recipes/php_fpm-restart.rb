#
# Cookbook Name:: deploy
# Recipe:: php-restart
#

include_recipe "deploy"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php_fpm'
    Chef::Log.debug("Skipping deploy::php_fpm-restart application #{application} as it is not a PHP-FPM app")
    next
  end
  
  execute "restart PHP-FPM" do
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    action :run
    
    only_if do 
      File.exists?(deploy[:current_path])
    end
    
    notifies :restart, "service[php5-fpm]"
  end
    
end


