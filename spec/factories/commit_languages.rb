# This will guess the User class
FactoryGirl.define do
  factory :commit_language do
    extention 'rb'

    trait :coffee do
      extention 'coffee'
    end

    trait :with_commit do
      commit_id { FactoryGirl.create(:commit).id }
    end
  end
end
