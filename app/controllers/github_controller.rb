class GithubController < ApplicationController
  def index
    @site_commits = Commit.where(repo_full_name: ['kagd/R2D2', 'kagd/C3PO']).order('date DESC').group_by{|commit| commit.date.strftime('%B').downcase }
    @site_commits.keys.each do |month|
      @site_commits[month] = CommitPresenter.wrap @site_commits[month]
    end
    @total_commits = Commit.all.count
    # get all uniq repo_full_names
    @total_repos = Commit.uniq.pluck(:repo_full_name).count
    @language_counts = CommitLanguageService.percentages
  end
end
