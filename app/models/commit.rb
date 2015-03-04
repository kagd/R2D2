class Commit < ActiveRecord::Base
  has_many :commit_languages
end
