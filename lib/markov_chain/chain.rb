# The Chain represents Markov info as it's being assembled or expanded from a text. To compensate
# for small sample sizes, we track multiple chains (derived from both two-word phrases and single word). Phrases are prefered, but if we can't find a match, we'll try with a single word.
module MarkovChain
  class Chain
    def initialize
      @one_key_dictionary = Dictionary.new
      @two_key_dictionary = Dictionary.new
    end

    attr_reader :one_key_dictionary, :two_key_dictionary
    def lengthen(word, next_word:, previous_word: nil)
      @one_key_dictionary.push(word, next_word)
      @two_key_dictionary.push(two_word_key(previous_word, word), next_word)
      word
    end

    def next_word(word, previous_word: nil)
      result_for_two_words(previous_word, word) || result_for_one_word(word)
    end

    protected

    def result_for_two_words(previous_word, word)
      @two_key_dictionary.next_word(two_word_key(previous_word, word)) if previous_word
    end

    def result_for_one_word(word)
      @one_key_dictionary.next_word(word)
    end

    # We represent the two words as a space-delimited phrase for simplicity and speed of access via
    # hash keys.
    def two_word_key(word1, word2)
      "#{word1} #{word2}"
    end
  end
end

