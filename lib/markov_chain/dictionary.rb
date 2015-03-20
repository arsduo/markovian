# This class represents a dictionary of words or phrases and the various words that can follow
# them.  Currently it's implemented as a hash of arrays, but more advanced representations may
# follow.
#
# The key is an opaque value, which could represent either a single word or a phrase as desired.
module MarkovChain
  class Dictionary
    def push(key, word)
      dictionary[key] += [word]
    end

    def next_word(key)
      dictionary[key].sample
    end

    protected

    def dictionary
      @dictionary ||= Hash.new([])
    end
  end
end
