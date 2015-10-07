class RunDiabloServices < ActiveRecord::Migration
  def up
    service = GithubService.new
    service.run
  end

  def down
  end
end
