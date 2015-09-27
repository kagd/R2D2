class CommitService
  attr_reader :commits

  def initialize(commits)
    @commits = commits
  end

  def group_by_year_month
    grouped_commits = []
    grouped_years = commits.group_by{|commit| commit.date.strftime('%Y').to_s }

    # @site_commits = commits.group_by{|commit| commit.date.strftime('%Y').to_s }

    grouped_years.each do |year, year_commits|
      grouped_months = year_commits.group_by{|commit| commit.date.strftime('%-m').to_s }

      grouped_months.each do |month, month_commits|
        wrapped_commits = CommitPresenter.wrap month_commits

        grouped_commits << [year, [month, wrapped_commits]]
      end
    end

    grouped_commits
  end
end
