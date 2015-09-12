require 'markovian/corpus/chain'

# This class represents a pair of chains, one going forward and one going backward. With this, we
# can construct phrases in which the original seed word appears at any point in the text (going
# backward to create the earlier text, forward to create the rest).
module Markovian
  class Corpus
    attr_reader :forward, :backward
    def initialize
      @forward, @backward = Chain.new, Chain.new
    end

    def next_word(word, previous_word: nil)
      forward.next_word(word, previous_word: previous_word)
    end

    def previous_word(word, following_word: nil)
      # backward goes in the opposite direction to forward
      backward.next_word(word, previous_word: following_word)
    end

    def random_word
      forward.random_word
    end

    def ==(other)
      self.forward == other.forward &&
        self.backward == other.backward
    end
  end
end
