#
# Cookbook Name:: mime_types
# Recipe:: default
#
service "nginx" do
  supports :status => true, :restart => true, :reload => true
end
if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  remote_file "/data/nginx/mime.types" do
    owner "root"
    group "root"
    mode 0755
    source "mime.types"
    notifies :reload, resources(:service => "nginx")
    backup false
    action :create
  end
end