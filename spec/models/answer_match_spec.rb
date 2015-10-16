require 'rails_helper'

RSpec.describe AnswerMatch, type: :model do
  describe '.with_convert' do
    subject { AnswerMatch.with_convert(answer, correct_answer) }

    context 'when correct answer is downcase' do
      let(:correct_answer) { 'John' }
      let(:answer) { 'john' }

      it 'upcase answer matches' do
        expect(subject).to eq true
      end
    end

    context 'when correct answer is hiragana' do
      let(:correct_answer) { 'はんざわ' }
      let(:answer) { 'ハンザワ' }

      it 'katakana answer matches' do
        expect(subject).to eq true
      end
    end
  end

  describe '.on_last_name' do
    subject { AnswerMatch.on_last_name(answer, correct_answer) }

    context 'when correct answer has 3 characters' do
      let(:correct_answer) { '上戸彩' }

      describe 'answer matches' do
        describe 'with aenough character' do
          let(:answer) { '上' }
          example { expect(subject).to eq true }
        end
      end
    end

    context 'when correct answer has 4 characters' do
      let(:correct_answer) { '半沢直樹' }

      describe 'answer matches' do
        describe 'with correct last name' do
          let(:answer) { '半沢' }
          example { expect(subject).to eq true }
        end
      end

      describe 'answer does not matches' do
        describe 'with a not enough character' do
          let(:answer) { '半' }
          example { expect(subject).to eq false }
        end
      end
    end

    context 'when correct answer has 5 characters' do
      let(:correct_answer) { '古畑任三郎' }

      describe 'answer matches' do
        describe 'with enough and correct characters' do
          let(:answer) { '古畑' }
          example { expect(subject).to eq true }
        end
      end
    end
  end

  describe '.on_first_name' do
    subject { AnswerMatch.on_first_name(answer, correct_answer) }

    context 'when correct answer has 3 characters' do
      let(:correct_answer) { '上戸彩' }

      describe 'answer matches' do
        describe 'with enought and correct characters' do
          let(:answer) { '彩' }
          example { expect(subject).to eq true }
        end
      end
    end

    context 'when correct answer has 4 characters' do
      let(:correct_answer) { '半沢直樹' }

      describe 'answer matches' do
        describe 'with enought and correct characters' do
          let(:answer) { '直樹' }
          example { expect(subject).to eq true }
        end
      end

      describe 'answer does not matches' do
        describe 'with a not enough character' do
          let(:answer) { '樹' }
          example { expect(subject).to eq false }
        end
      end
    end

    context 'when correct answer has 5 characters' do
      let(:correct_answer) { '古畑任三郎' }

      describe 'answer matches' do
        describe 'with enough and correct characters' do
          let(:answer) { '三郎' }
          example { expect(subject).to eq true }
        end
      end
    end
  end

  describe '.kanji_to_hiragana' do
    subject { AnswerMatch.kanji_to_hiragana(kanji) }

    let(:kanji) { '半沢直樹' }
    let(:hiragana) { 'はんざわなおき' }

    it 'kanji was converted to hiragana' do
      expect(subject).to eq hiragana
    end
  end
end
