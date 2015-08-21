require 'rails_helper'

feature "quiz page", type: :feature do
  feature '出題ページを表示' do
    include_context 'login_as_user'
    let!(:answer_users) { FactoryGirl.create_list :user, 10, :with_user_profile }
    let!(:answer_user_profile) { answer_users.sample.user_profile }

    background do
      allow_any_instance_of(Array).to receive(:sample).and_return(answer_user_profile)
    end

    scenario 'クイズの問題と解答欄が表示される' do
      visit quiz_path

      expect(page).to have_selector('#user_image')
      expect(page).to have_field('answer_user_name')
      expect(find("#answer_user_id", visible: false).value.to_i).to eq answer_user_profile.id
    end

    feature '回答する' do
      context '正解の場合' do
        background do
          visit quiz_path

          fill_in 'answer_user_name', with: answer_user_profile.answer_name
          click_on 'answer'
        end

        scenario '回答したら結果が表示される' do
          expect(page).not_to have_css('div.notice', text: I18n.t('quiz.show.incorrect'))
        end

        scenario '相手のプロフィールが表示される ' do
          expect(page).to have_css('li', text: answer_user_profile.name)
          expect(page).to have_css('li', text: answer_user_profile.answer_name)
        end

        scenario '回答履歴に正解が記録される' do
          expect(page).to have_css('#total_correct', I18n.t('quiz.show.correct'))
          expect(page).to have_css('#total_correct', text: '1')

          expect(login_user.user_profile.total_correct).to eq 1
        end
      end

      context '不正解の場合' do
        let(:answer_name) { Forgery(:basic).text }

        background do
          visit quiz_path

          fill_in 'answer_user_name', with: answer_name
          click_on 'answer'
        end

        scenario '回答したら結果が表示される' do
          expect(page).to have_css('div.notice', text: I18n.t('quiz.show.incorrect_result', answer_name: answer_user_profile.answer_name))
        end

        scenario '回答履歴に不正解が記録される' do
          expect(page).to have_css('#total_incorrect', I18n.t('quiz.show.incorrect'))
          expect(page).to have_css('#total_incorrect', text: '1')

          expect(login_user.user_profile.total_incorrect).to eq 1
        end
      end
    end
  end
end
