FactoryGirl.define do
  factory :user_profile do
    user_id         { 3 }
    last_name       { Forgery('name').last_name }
    first_name      { Forgery('name').first_name }
    answer_name     { Forgery('name').name }
  end
end
