FactoryGirl.define do
  factory :profile_image do
    user_profile_id { Forgery(:basic).number }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'profile_image', 'images', 'logo_image.jpg')) }
  end
end
