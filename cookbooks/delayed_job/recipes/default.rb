node[:applications].each do |app_name, data|
  user = node[:users].first

  case node[:instance_role]
    when "util" #run DJ only on the util. instance - not to effect web-app responsivenes

      worker_name  = "#{app_name}_job_runner" #for multiple apps using delayed_job on same env.
      worker_count = 1
      
      worker_count.times do |count|
        template "/etc/monit.d/delayed_job#{count+1}.#{app_name}.monitrc" do
          source "dj.monitrc.erb"
          owner "root"
          group "root"
          mode 0644
          variables({
            :app_name => app_name,
            :user => node[:owner_name],
            :worker_name => "#{app_name}_delayed_job#{count+1}",
            :framework_env => node[:environment][:framework_env]
          })
        end
      end
    
      execute "monit reload" do
         action :run
         epic_fail true
      end
  end
end
