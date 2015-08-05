require 'rails_helper'

feature '登録者のプロフィール', type: :feature do
  feature 'プロフィールの表示' do
    let!(:user_profile) { FactoryGirl.create :user_profile }

    background do
      visit user_profile_path(user_profile)
    end

    scenario 'プロフィールが表示されること' do
      expect(page).to have_content user_profile.last_name
      expect(page).to have_content user_profile.first_name
    end
  end
end
