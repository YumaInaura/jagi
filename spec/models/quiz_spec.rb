require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe '.correct?' do
    describe 'Standard name' do
      let(:question_user_profile) { FactoryGirl.create :user_profile }

      describe 'is matched' do
        it 'at answer name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.user.name)).to be true
        end

        it 'at Google full name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.answer_name)).to be true
        end

        it 'at last name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.user.name[0..1])).to be true
        end

        it 'at first name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.user.name[-2..-1])).to be true
        end
      end
    end

    describe 'Japanese name' do
      let(:question_user) { FactoryGirl.create :user, :with_user_profile, name: '半沢直樹' }

      describe 'is matched' do
        describe 'on hiragana' do
          it 'at full name ' do
            expect(Quiz.correct?(question_user.user_profile, 'はんざわなおき')).to be true
          end

          it 'at full name with spece' do
            expect(Quiz.correct?(question_user.user_profile, 'はんざわ なおき')).to be true
          end

          it 'at last name' do
            expect(Quiz.correct?(question_user.user_profile, 'はんざわ')).to be true
          end

          it 'at first name' do
            expect(Quiz.correct?(question_user.user_profile, 'なおき')).to be true
          end
        end

        describe 'on katakana' do
          it 'at full name ' do
            expect(Quiz.correct?(question_user.user_profile, 'ハンザワナオキ')).to be true
          end

          it 'at last name' do
            expect(Quiz.correct?(question_user.user_profile, 'ハンザワ')).to be true
          end

          it 'at first name' do
            expect(Quiz.correct?(question_user.user_profile, 'ナオキ')).to be true
          end
        end
      end

      describe 'is not matched' do
        it 'at last name' do
          expect(Quiz.correct?(question_user.user_profile, 'はん')).to be false
        end

        it 'at first name' do
          expect(Quiz.correct?(question_user.user_profile, 'おき')).to be false
        end

        it 'at imcompleted name' do
          expect(Quiz.correct?(question_user.user_profile, 'んざわなお')).to be false
        end
      end
    end
  end
end
