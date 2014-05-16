include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not a Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_rails do
    deploy_data deploy
    app application
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  # options = {
  #   app: application,
  #   user: deploy[:user],
  #   log: "#{deploy[:deploy_to]}/shared/log",
  #   # procfile: "#{deploy[:deploy_to]}/current/config/foreman/Procfile",
  #   root: deploy[:current_path]
  # }.map { |k,v| "--#{k} #{v}" }.join(" ")

  # comando1 = "sudo bundle exec foreman export upstart /etc/init #{options}"
  # comando2 = "sudo /sbin/start #{application} || sudo /sbin/restart #{application}"

  comando3 = "sudo bundle exec sidekiq -C config/sidekiq.yml"

  execute "start sidekiq #{application}" do
    cwd deploy[:current_path]
    command comando3
    user deploy[:user]
  end

  # execute "export foreman config for #{application}" do
  #   cwd deploy[:current_path]
  #   command comando1
  #   user deploy[:user]
  # end

  # execute "start / restart foreman #{application}" do
  #   cwd deploy[:current_path]
  #   command comando2
  #   user deploy[:user]
  # end
end
