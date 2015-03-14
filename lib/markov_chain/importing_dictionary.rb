# The ImportingDictionary represents Markov info as it's being assembled or expanded from a text.
# Currently it's implemented as a hash of arrays, but more advanced representations may follow.
#
# This tracks both two-key and one-key followers -- this is more memory-intensive, but addresses
# the drawback of a small corpus, which is that you might end up with relatively few chains.
module MarkovChain
  class ImportingDictionary
    def initialize
      @one_key_dictionary = {}
      @two_key_dictionary = {}
      # ensure that the dictionary's default will be an empty array, regardless of how it's
      # initially loaded
      @one_key_dictionary.default = @two_key_dictionary.default = []
    end

    attr_reader :one_key_dictionary, :two_key_dictionary
    def push(word, next_word:, previous_word: nil)
      @one_key_dictionary[word] += [next_word]
      @two_key_dictionary[two_word_key(previous_word, word)] += [next_word]
    end

    def next_word(word, previous_word: nil)
      result_for_two_words(previous_word, word) || result_for_one_word(word)
    end

    protected

    def result_for_two_words(previous_word, word)
      @two_key_dictionary[two_word_key(previous_word, word)].sample if previous_word
    end

    def result_for_one_word(word)
      @one_key_dictionary[word].sample
    end

    # We represent the two words as a space-delimited phrase for simplicity and speed of access via
    # hash keys.
    def two_word_key(word1, word2)
      "#{word1} #{word2}"
    end
  end
end

