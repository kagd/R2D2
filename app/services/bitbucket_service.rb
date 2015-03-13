require 'pp'

class BitbucketService < BaseService
  include HTTParty
  attr_reader :commits
  # for use in HTTParty
  base_uri 'https://bitbucket.org/api'

  # def initialize
  #   @auth = {
  #     username: ENV['BITBUCKET_USERNAME'],
  #     password: ENV['BITBUCKET_TOKEN']
  #   }
  # end

  def run
    @commits = user_repos.map do |repo_name|
      user_commits(repo_name)
    end.flatten
  end

  def user_repos
    response = v1 'user/repositories'
    json = JSON.parse response.body
    hash = json.map &:deep_symbolize_keys
    hash.map{|item| item[:name]}
  end

  def user_commits(repo)
    response = v2 "repositories/#{ENV['BITBUCKET_USERNAME']}/#{repo}/commits"
    user_commits = []
    values = response['values']

    while response['next'].present? do
      path = response['next'].gsub(self.class.base_uri, '')

      response = get path
      values << response['values']
    end

    values.flatten.each do |value|
      begin
        is_user_commit = value['author']['user']['username'] == ENV['BITBUCKET_AUTHOR']
      rescue
        is_user_commit = value['author']['raw'].match ENV['BITBUCKET_FULL_NAME']
      end

      if is_user_commit
        user_commits << value
      end
    end

    user_commits
  end

private

  def v1(path)
    get "/1.0/#{path}"
  end

  def v2(path)
    get "/2.0/#{path}"
  end

  def get(path)
    puts "getting #{path}"
    self.class.get path, {:basic_auth => auth}
  end

  def auth
    {
      username: ENV['BITBUCKET_USERNAME'],
      password: ENV['BITBUCKET_TOKEN']
    }
  end
end
