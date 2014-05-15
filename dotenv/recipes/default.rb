node[:deploy].each do |application, deploy|
	deploy_app = node[:deploy][application]

	Chef::Log.debug("Create .env file for app #{application} on shared dir.")

	template "#{deploy[:deploy_to]}/shared/config/.env" do
	  source "dotenv.erb"
	  owner deploy[:user]
	  group deploy[:group]
	  mode 00755
	  variables :dotenvs => deploy_app[:dotenv]
	  only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
	end
end