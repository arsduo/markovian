# The ImportingDictionary represents Markov info as it's being assembled or expanded from a text.
# Currently it's implemented as a hash of arrays, but more advanced representations may follow.
module MarkovChain
  class ImportingDictionary
    def initialize(starter_dictionary = nil)
      @dictionary = starter_dictionary || {}
      # ensure that the dictionary's default will be an empty array, regardless of how it's
      # initially loaded
      @dictionary.default = []
    end

    def push(word1, word2, word3)
      # because we don't know what the starter diction
      dictionary[key(word1, word2)] += [word3]
    end

    def [](phrase)
      dictionary[phrase]
    end

    protected
    attr_reader :dictionary

    # We represent the two words as a space-delimited phrase for simplicity and speed of access via
    # hash keys.
    def key(word1, word2)
      "#{word1} #{word2}"
    end
  end
end

