class Quiz
  require 'nkf'

  attr_accessor :total, :correct, :incorrect

  def initialize(params)
    @user_id    = params[:user_id]
    @conditions = params[:conditions]
    @questions  = params[:questions] || questions
    @answers    = params[:answers] || []
    @total      = params[:total] || 0
    @correct    = params[:correct] || 0
    @incorrect  = params[:incorrect] || 0
  end

  def next_question
    UserProfile.find_by(user_id: @questions[@answers.count])
  end

  def last_question
    UserProfile.find_by(user_id: @questions[@answers.count - 1])
  end

  def last_result
    self.class.correct?(last_question, @answers.last)? :win : :lose
  end

  def fin?
    @questions.count == @questions.answers.count
  end

  def answer!(answer_name)
    @answers << answer_name
    increment_result
  end

  private

  def increment_result
    if last_result == :win
      @correct   += 1
    else
      @incorrect += 1
    end
    @total += 1
  end

  def questions
    UserProfile.
      without_user(@user_id).
      with_image.
      with_group(@conditions[:group_id]).
      with_project(@conditions[:project_id]).
      with_gender(@conditions[:gender]).
      with_joined_year(@conditions[:joined_year]).
      pluck(:user_id).
      shuffle
  end

  class << self
    def correct?(user_profile, answer_text)
      answer_text.strip!
      return false if answer_text.blank?

      converting_match(answer_text, user_profile.answer_name) ||
      fazzy_match(answer_text, user_profile.name) ||
      natural_language_match(answer_text, user_profile.name)
    end

    # 氏名等をゆるく判定 (最初か最後の文字が、ある程度一致したらマッチ)
    def fazzy_match(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      (
      katakana_to_hiragana(answer_text) == full_name ||
      katakana_to_hiragana(answer_text).match("^#{full_name[0..1]}") ||
      katakana_to_hiragana(answer_text).match("#{full_name[-2..-1]}$")
      ) && true || false
    end

    def converting_match(answer_text, name)
      return false if answer_text.blank? || name.blank?

      katakana_to_hiragana(name) == katakana_to_hiragana(answer_text)
    end

    # 漢字氏名を自然言語処理でひらがなに変えて判定
    def natural_language_match(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      hiragana_full_name = `printf '#{full_name}' | nkf -e | kakasi -JH | nkf -w`

      converting_match(answer_text, hiragana_full_name) ||
      last_name_match(answer_text, hiragana_full_name) ||
      first_name_match(answer_text, hiragana_full_name)
    end

    def last_name_match(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      last_name_length = ((full_name.length+1)/2)-1
      (katakana_to_hiragana(answer_text).match("^#{full_name[0..last_name_length]}") && true) || false
    end

    def first_name_match(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      first_name_length = (-(full_name.length)/2)+1
      (katakana_to_hiragana(answer_text).match("#{full_name[first_name_length..-1]}$") && true) || false
    end

    def katakana_to_hiragana(answer_text)
      NKF.nkf("--hiragana -w", answer_text)
    end
  end
end
