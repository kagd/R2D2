# app/workers/github_worker.rb

class DiabloWorker
  include Sidekiq::Worker

  def perform
    service = D3Service.new
    service.run
  end
end
