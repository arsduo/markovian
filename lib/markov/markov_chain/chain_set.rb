module MarkovChain
  # This class represents a pair of chains, one going forward and one going backward. With this, we
  # can
  class ChainSet
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
  end
end
