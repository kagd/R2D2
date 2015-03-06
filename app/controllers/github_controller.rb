class GithubController < ApplicationController
  def index
    commits = Commit.where(repo_full_name: ['kagd/R2D2', 'kagd/C3PO']).order('date DESC')

    @site_commits = commits.group_by{|commit| commit.date.strftime('%Y') }

    @site_commits.each do |year, year_commits|
      @site_commits[year] = year_commits.group_by{|commit| commit.date.strftime('%B').titleize }

      @site_commits[year].each do |month, month_commits|
        @site_commits[year][month] = CommitPresenter.wrap month_commits
      end
    end

    @total_commits = Commit.all.count

    # get all uniq repo_full_names
    @total_repos = Commit.uniq.pluck(:repo_full_name).count
    @language_counts = CommitLanguageService.percentages
  end
end
