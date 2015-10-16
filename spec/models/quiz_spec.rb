require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe '.correct?' do
    context 'When correct answer is English' do
      let(:question_user_profile) { FactoryGirl.create :user_profile }

      describe 'Answer matches' do
        example 'to free style correct answer' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.user.name)).to be true
        end

        example 'with full name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.answer_name)).to be true
        end

        example 'with last name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.user.name[0..1])).to be true
        end

        example 'with first name' do
          expect(Quiz.correct?(question_user_profile, question_user_profile.user.name[-2..-1])).to be true
        end
      end

      describe 'Answer does not matches' do
        example 'with empty text' do
          expect(Quiz.correct?(question_user_profile, '')).to be false
        end

        example 'with space all text' do
          expect(Quiz.correct?(question_user_profile, ' ')).to be false
        end
      end
    end

    context 'When correct answer is Japanese' do
      let(:question_user) { FactoryGirl.create :user, :with_user_profile, name: '半沢直樹' }

      describe 'Hiragana answer' do
        describe 'Matches' do
          example 'with full name ' do
            expect(Quiz.correct?(question_user.user_profile, 'はんざわなおき')).to be true
          end

          example 'with has space full name' do
            expect(Quiz.correct?(question_user.user_profile, 'はんざわ なおき')).to be true
          end

          example 'with last name' do
            expect(Quiz.correct?(question_user.user_profile, 'はんざわ')).to be true
          end

          example 'with first name' do
            expect(Quiz.correct?(question_user.user_profile, 'なおき')).to be true
          end
        end

        describe 'Does not matches' do
          example 'with not enough length name.' do
            expect(Quiz.correct?(question_user.user_profile, 'はん')).to be false
            expect(Quiz.correct?(question_user.user_profile, 'おき')).to be false
          end

          example 'with imcompleted name.' do
            expect(Quiz.correct?(question_user.user_profile, 'んざわなお')).to be false
          end
        end
      end

      describe 'Katakana answer' do
        describe 'Matches' do
          example 'with full name ' do
            expect(Quiz.correct?(question_user.user_profile, 'ハンザワナオキ')).to be true
          end

          example 'with last name' do
            expect(Quiz.correct?(question_user.user_profile, 'ハンザワ')).to be true
          end

          example 'with first name' do
            expect(Quiz.correct?(question_user.user_profile, 'ナオキ')).to be true
          end
        end
      end
    end
  end
end
