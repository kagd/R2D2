# This will guess the User class
FactoryGirl.define do
  factory :commit do
    repo_full_name "kagd/R2D2"
    message  "Upgrading to Rails 4.0"
    date { Time.now }
    additions 332
    deletions 87
    number_of_files 32
    sha 'ec7d502ca19aec4fc34c4043b372f54382b67d6d'
    source 'bitbucket'
  end
end
