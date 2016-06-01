# lib/capistrano/tasks/assets.rake

desc "Update github, D3, etc"
namespace :update do
  task :all do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{fetch(:deploy_to)}/current" do
        as :deploy do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'update:all'
          end
        end
      end
    end
  end
end
