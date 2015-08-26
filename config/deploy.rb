lock '3.2.1'

set :application, 'jagi'
set :repo_url, 'https://github.com/Yinaura/jagi'
set :branch, 'capistrano'
set :rbenv_ruby, '2.2.3'

set :deploy_to, '/var/www/app/jagi'
set :scm, :git

set :linked_dirs, %w{log tmp/pids tmp/cache vendor/bundle public/system}
set :linked_files, %w{.env}

set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart
end
