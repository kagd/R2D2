class CommitService
  attr_reader :commits

  def initialize(commits)
    @commits = commits
  end

  def group_by_year_month
    @site_commits = commits.group_by{|commit| commit.date.strftime('%Y') }

    @site_commits.each do |year, year_commits|
      @site_commits[year] = year_commits.group_by{|commit| commit.date.strftime('%B').titleize }

      @site_commits[year].each do |month, month_commits|
        @site_commits[year][month] = CommitPresenter.wrap month_commits
      end
    end
  end
end
