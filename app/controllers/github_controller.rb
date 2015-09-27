class GithubController < ApplicationController
  def index
    commits = Commit.where(repo_full_name: ['kagd/R2D2', 'kagd/kagd.github.io']).order('date DESC')

    service = CommitService.new commits
    @site_commits = commits.size

    @total_commits = Commit.all.count

    # get all uniq repo_full_names
    @total_repos = Commit.uniq.pluck(:repo_full_name).count
    @language_counts = CommitLanguageService.percentages
  end
end
