json.number_of_commits @commits.size
json.last_commit do
  json.message @last_commit.message
  json.time_ago "#{time_ago_in_words(@last_commit.date)} ago"
  json.sha @last_commit.sha
  json.repo @last_commit.repo_full_name
end
