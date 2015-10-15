class AnswerMatch
  require 'nkf'

  class << self
    # 氏名等をゆるく判定 (最初か最後の文字が、ある程度一致したらマッチ)
    def with_fuzzy_on_full_name(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      !!(
      katakana_to_hiragana(answer_text) == full_name ||
      katakana_to_hiragana(answer_text).match("^#{full_name[0..1]}") ||
      katakana_to_hiragana(answer_text).match("#{full_name[-2..-1]}$")
      )
    end

    # カタカナとひらがな / 大文字と小文字 を揃えて判定
    def with_convert(answer_text, name)
      return false if answer_text.blank? || name.blank?

      katakana_to_hiragana(name) == katakana_to_hiragana(answer_text)
    end

    # 漢字氏名を自然言語処理でひらがなに変えて判定
    def with_natural_language_on_full_name(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      hiragana_full_name = kanji_to_hiragana(full_name)

      with_convert(answer_text, hiragana_full_name) ||
      on_last_name(answer_text, hiragana_full_name) ||
      on_first_name(answer_text, hiragana_full_name)
    end

    def on_last_name(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      if full_name.length.even?
        match_length = ((full_name.length+1)/2)-1
      else
        match_length = ((full_name.length+1)/2)-2
      end

      !!(katakana_to_hiragana(answer_text).match("^#{full_name[0..match_length]}"))
    end

    def on_first_name(answer_text, full_name)
      return false if answer_text.blank? || full_name.blank?

      if full_name.length.even?
        match_length = (-(full_name.length)/2)
      else
        match_length = (-(full_name.length)/2)+1
      end

      !!(katakana_to_hiragana(answer_text).match("#{full_name[match_length..-1]}$"))
    end

    def kanji_to_hiragana(text)
      `printf '#{text}' | nkf -e | kakasi -JH | nkf -w`
    end

    def katakana_to_hiragana(text)
      NKF.nkf("--hiragana -w", text)
    end
  end
end
