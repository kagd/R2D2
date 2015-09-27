class BitbucketService < BaseService
  include HTTParty
  include ActionView::Helpers::TextHelper
  attr_reader :commits
  # for use in HTTParty
  base_uri 'https://bitbucket.org/api'

  def initialize
    @saved_commit_shas = Commit.where(source: 'bitbucket').select(:sha).map(&:sha)
  end

  def run
    repos.each do |repo_name|
      commits = user_changesets(repo_name)

      commits.each do |commit|
        stats = changeset_diff repo_name, commit['raw_node']

        commit_hash = {
          repo_full_name:  "#{ENV['BITBUCKET_OWNER']}/#{repo_name}",
          message:         truncate(commit['message'], length: 255),
          date:            commit['utctimestamp'],
          additions:       stats[:additions],
          deletions:       stats[:deletions],
          number_of_files: commit['files'].size,
          sha:             commit['raw_node'],
          source:          'bitbucket'
        }

        Commit.transaction do
          CommitLanguage.transaction do
            saved_commit = Commit.create(commit_hash)

            commit['files'].each do |file|
              matches = file['file'].match(/([\w]+)\z/)

              if matches.present?
                ext = matches[0]
                CommitLanguage.create extention: ext, commit_id: saved_commit.id
              end
            end
          end
        end
      end
    end
  end

  def repos
    response = v1 'user/repositories'
    json = JSON.parse response.body
    json.map{|item| item['name']}
  end

  def user_changesets(repo)
    limit = 50
    response = v1 "repositories/#{ENV['BITBUCKET_OWNER']}/#{repo}/changesets?limit=#{limit}"
    total_commit_count = response['count']
    @commits = response['changesets']

    while @commits.size < total_commit_count do
      start_raw_node = get_last_commit['raw_node']
      response = v1 "repositories/#{ENV['BITBUCKET_OWNER']}/#{repo}/changesets?limit=#{limit}&start=#{start_raw_node}"

      response['changesets'].each do |changeset|
        # use the unless because the bitbucket API includes the starting node,
        # which means that if there are 4 calls, 3 changesets will be duplicated
        unless start_raw_node == changeset['raw_node']
          @commits << changeset
        end
      end
    end

    user_commits = []

    @commits.each do |commit|
      if [ENV['BITBUCKET_FULL_NAME'], ENV['BITBUCKET_AUTHOR']].include?(commit['author']) && !@saved_commit_shas.include?(commit['raw_node'])
        user_commits << commit
      end
    end

    user_commits

    # if response['changesets'].map{|cs| cs[:hash]}.include? last_commit_sha
  end

  def changeset_diff(repo, sha)
    response = v1 "repositories/#{ENV['BITBUCKET_OWNER']}/#{repo}/changesets/#{sha}/diff"

    stats = {
      additions: 0,
      deletions: 0
    }

    if response.code == 200
      response.each do |file|
        file['hunks'].each do |hunk|
          stats[:deletions] = stats[:deletions] + hunk['from_lines'].size
          stats[:additions] = stats[:additions] + hunk['to_lines'].size
        end
      end
    end

    stats
  end

private

  def v1(path)
    get "/1.0/#{path}"
  end

  def v2(path)
    get "/2.0/#{path}"
  end

  def get(path)
    talk "getting #{path}"
    self.class.get path, {:basic_auth => auth}
  end

  def get_last_commit
    sorted_commits = @commits.sort_by{|commit| Time.parse commit['utctimestamp'] }

    sorted_commits.first
  end

  def auth
    {
      username: ENV['BITBUCKET_OWNER'],
      password: ENV['BITBUCKET_TOKEN']
    }
  end

  def last_commit_date_for_repo(repo_full_name)
    # if previous commit is cached, return that one
    if @last_commit_date_for_repo[repo_full_name].present?
      @last_commit_date_for_repo[repo_full_name]
    else
      # Search for last commit by commit date
      commit = Commit.where(repo_full_name: repo_full_name).order("date DESC").first

      if commit.present?
        # add 1 second because the api search will return this commit since it matches the date since
        @last_commit_date_for_repo[repo_full_name] = (commit.date + 1.second).utc.iso8601
      else
        @last_commit_date_for_repo[repo_full_name] = nil
      end
    end
  end
end
