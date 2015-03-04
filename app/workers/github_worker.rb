# app/workers/github_worker.rb

class GithubWorker
  include Sidekiq::Worker

  def perform
    service = GithubService.new
    service.run
  end
end
