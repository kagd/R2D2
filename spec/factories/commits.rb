# This will guess the User class
FactoryGirl.define do
  factory :commit do
    repo_full_name "kagd/C3PO"
    message  "Upgrading to Rails 4.0"
    date { Date.now }
    additions 332
    deletions 87
    number_of_files 32
  end
end
