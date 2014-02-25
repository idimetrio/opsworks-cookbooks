#
# Cookbook Name:: deploy
# Recipe:: php-undeploy

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php_fpm'
    Chef::Log.debug("Skipping deploy::php_fpm-undeploy application #{application} as it is not an PHP-FPM app")
    next
  end

  link "#{node[:nginx][:dir]}/sites-enabled/#{application}.conf" do
    action :delete
    only_if do
      ::File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{application}.conf")
    end
  end

  file "#{node[:nginx][:dir]}/sites-available/#{application}.conf" do
    action :delete
    only_if do
      ::File.exists?("#{node[:nginx][:dir]}/sites-available/#{application}.conf")
    end
  end

  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete
    only_if do
      ::File.exists?("#{deploy[:deploy_to]}")
    end
  end
end
