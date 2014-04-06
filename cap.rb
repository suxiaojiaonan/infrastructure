set :stages, %w(development production)
require "capistrano/ext/multistage"
require "railsless-deploy"
require "rubygems"

#基本設定
set :application, "davinci"
set :use_sudo, false
set :deploy_to, "/var/www/davinci/davinci_server"
set :deploy_via, :copy

#リポジトリ設定
set :scm, :git
set :repository, url

#SSH設定
set :normalize_asset_timestamps, false

set :user, "deployuser"
ssh_options[:port] = "22"
ssh_options[:keys] = %w(/home/deployuser/.ssh/deployuser)
default_run_options[:pty] = true

#フレームワーク設定
set :logs_path, "application/logs"

after "deploy", "deploy:create_app_symlink"
#after "deploy:setup", "deploy:chown_log_dir"

namespace :deploy do
task :finalize_update, :roles => :web do
run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)
# overide the rest of the default method
end
task :create_app_symlink, :roles => :web do
run "rm -f #{deploy_to}/system; ln -s #{deploy_to}/current/system #{deploy_to}/system"
if previous_release
run "mv -f #{previous_release}/#{logs_path}/* #{latest_release}/#{logs_path}"
end
run " chmod 755 #{deploy_to}/current/application/logs"
end
end
