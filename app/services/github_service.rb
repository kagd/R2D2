class GithubService < BaseService
  include ActionView::Helpers::TextHelper
  attr_reader :client

  DAY_MAPPING = {
    '0' => 'monday',
    '1' => 'tuesday',
    '2' => 'wednesday',
    '3' => 'thursday',
    '4' => 'friday',
    '5' => 'saturday',
    '6' => 'sunday'
  }

  def initialize
    Octokit.auto_paginate = true
    @client = Octokit::Client.new access_token: ENV['GITHUB_TOKEN']
    @last_commit_date_for_repo = {}
  end

  # Get all repos the user has access too
  def repos
    @repos ||= (user_repos + org_repos).flatten
  end

  def run
    repos.each do |repo|
      talk "Getting commits for #{repo[:full_name]}"

      # pull back all user commits for repo
      commits = client.commits repo[:full_name], commit_options(repo)

      commits.map do |commit|
        # get detailed commit for repo
        # it contains the files and stats saved to DB
        commit = client.get commit[:url]

        commit_hash = {
          repo_full_name:  repo[:full_name],
          message:         truncate(commit[:commit][:message], length: 255),
          date:            commit[:commit][:committer][:date],
          additions:       commit[:stats][:additions],
          deletions:       commit[:stats][:deletions],
          number_of_files: commit[:files].size,
          sha:             commit[:sha]
        }

        Commit.transaction do
          CommitLanguage.transaction do
            saved_commit = Commit.create commit_hash

            commit[:files].each do |file|
              matches = file[:filename].match(/([\w]+)\z/)

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

  # Get all user repos
  def user_repos
    @user_repos ||= (
      talk 'user repos'
      client.repos
    )
  end

  # Get all user organizations
  def orgs
    client.organizations
  end

  # Get repos for all organizations
  def org_repos
    @org_repos ||= (
      talk 'org repos'
      logins = orgs.map { |org| org[:login] }

      logins.map do |login|
        talk "repos for #{login}"
        client.organization_repositories login.to_s
      end.flatten
    )
  end

  def commits_by_day(repo='kagd/prototypeof')
    @commits_by_day ||= (
      stats = {}
      # Pulls back an array of arrays: [[0,0,0],[0,1,0]] etc
      commits_by_day = client.punch_card_stats repo

      # this is creating a hash of
      commits_by_day.each do |array|
        # array[0] is a zero based index representation of days of the week.
        # we want to use the string version
        day_of_week =    DAY_MAPPING[array[0].to_s]
        hour_of_day =    array[1]
        num_of_commits = array[2]

        unless stats[day_of_week].present?
          stats[day_of_week] = {}
        end

        stats[day_of_week][hour_of_day] = num_of_commits
      end

      # select days that have commits
      days_with_commits = stats.select do |day, hour_commits|
        hour_commits.select{|hour, commit_number| commit_number > 0 }.any?
      end

      days_and_hours_of_commit = {}
      # Remove the hours that do NOT have commits
      days_with_commits.keys.each do |day_of_week|
        hours_with_commits = days_with_commits[day_of_week].select{ |hour, commit_number| commit_number > 0 }
        days_and_hours_of_commit[day_of_week] = hours_with_commits
      end

      # Add labels for hours an number of commits
      days_and_hours_of_commit.each do |day_of_week, hour_commits|
        hour_commits.each do |hour, commit_number|

          # We want to convert the day of week value to an array
          unless days_and_hours_of_commit[day_of_week].is_a?(Array)
            days_and_hours_of_commit[day_of_week] = []
          end

          days_and_hours_of_commit[day_of_week] << {
            hour: hour,
            commits: commit_number
          }
        end
      end

      days_and_hours_of_commit
    )
  end

  private #------------------------------------------------------

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

  def commit_options(repo)
    commit_options = {
      author: ENV['GITHUB_LOGIN']
    }

    last_commit_date = last_commit_date_for_repo(repo[:full_name])

    if last_commit_date.present?
      commit_options[:since] = last_commit_date
    end

    return commit_options
  end

end
