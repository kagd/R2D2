class GithubController < ApiController
  def index
    @commits = Commit.where(repo_full_name: ['kagd/R2D2', 'kagd/kagd.github.io', 'kagd/grantrklinsing.com']).order('date ASC')
    @last_commit = @commits.last

    # service = CommitService.new commits
    # @site_commits = commits.size
    # @last_commit = commits.last

    # @total_commits = Commit.all.count

    # get all uniq repo_full_names
    # @total_repos = Commit.uniq.pluck(:repo_full_name).count
    # @language_counts = CommitLanguageService.percentages
  end
end
