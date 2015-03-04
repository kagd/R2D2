
namespace :update do
  desc "Update Github"
  task :github => :environment do
    service = GithubService.new
    service.run
  end

  desc "Update Diablo"
  task :diablo => :environment do
    service = D3Service.new
    service.run
  end

  desc "Update All Services"
  task :all => :environment do
    Rake::Task['update:github'].invoke
    Rake::Task['update:diablo'].invoke
  end
end
