require 'rails_helper'

# http://qiita.com/asukiaaa/items/2dd7ed44f6903bc15055

feature '登録者のプロフィール', type: :feature do

  service = :google_oauth2
  include_context 'setup_OmniAuth_config', service
  include_context 'login_as_user'

  feature 'プロフィールの表示' do
    let!(:user_profile) { FactoryGirl.create :user_profile }

    background do
      visit user_profile_path(user_profile)
    end

    scenario 'プロフィールが表示されること' do
      expect(page).to have_content user_profile.first_name
      expect(page).to have_content user_profile.last_name
      expect(page).to have_content user_profile.answer_name
    end
  end

  feature 'プロフィールの作成' do

    let!(:new_last_name) { Forgery('name').last_name }
    let!(:new_first_name) { Forgery('name').first_name }
    let!(:new_answer_name) { Forgery('name').name }

    background do
      visit new_user_profile_path()
    end

    scenario 'プロフィールが作成できる' do

      fill_in 'user_profile_last_name', with: new_last_name
      fill_in 'user_profile_first_name', with: new_first_name
      fill_in 'user_profile_answer_name', with: new_answer_name
      click_on 'Create User profile'

      expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
      expect(page).to have_field 'user_profile_last_name', new_last_name
      expect(page).to have_field 'user_profile_first_name', new_first_name
      expect(page).to have_field 'user_profile_answer_name', new_answer_name

      expect(current_path).to eq edit_user_profile_path(UserProfile.first)

      expect(UserProfile.first.last_name).to eq new_last_name
      expect(UserProfile.first.first_name).to eq new_first_name
      expect(UserProfile.first.answer_name).to eq new_answer_name

      visit new_user_profile_path()
      expect(current_path).to eq edit_user_profile_path(UserProfile.first)
      expect(page).to have_field 'user_profile_last_name', new_last_name
      expect(page).to have_field 'user_profile_first_name', new_first_name
      expect(page).to have_field 'user_profile_answer_name', new_answer_name
    end
  end

  feature 'プロフィールの編集' do
    let!(:user_profile) { FactoryGirl.create :user_profile }
    let!(:new_last_name) { Forgery('name').last_name }
    let!(:new_first_name) { Forgery('name').first_name }
    let!(:new_answer_name) { Forgery('name').name }

    background do
      visit edit_user_profile_path(user_profile)
    end

    scenario 'プロフィールが編集できる' do
      fill_in 'user_profile_last_name', with: new_last_name
      fill_in 'user_profile_first_name', with: new_first_name
      fill_in 'user_profile_answer_name', with: new_answer_name
      click_on 'Update User profile'

      expect(current_path).to eq edit_user_profile_path(user_profile)

      expect(page).to have_content I18n.t('user_profiles.update.flash_edited')
      expect(page).to have_field 'user_profile_last_name', new_last_name
      expect(page).to have_field 'user_profile_first_name', new_first_name
      expect(page).to have_field 'user_profile_answer_name', new_answer_name

      expect(UserProfile.first.last_name).to eq new_last_name
      expect(UserProfile.first.first_name).to eq new_first_name
      expect(UserProfile.first.answer_name).to eq new_answer_name
    end
  end

end
