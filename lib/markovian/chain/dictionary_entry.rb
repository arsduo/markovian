module Markovian
  class Chain
    class DictionaryEntry
      # Below this, we don't have enough occurrences to draw conclusions about how a word is used.
      # Longer-term, this could possibly be calculated in a more dynamic and effective way by
      # analyzing the corpus itself.
      SIGNIFICANT_OCCURRENCE_THRESHOLD = 500

      attr_reader :word, :counts
      def initialize(word)
        @word = word.to_s
        @next_words = []
        @counts = Hash.new(0)
      end

      def record_observance(word_instance)
        # The word has been observed, so let's increase the appropriate counts.
        @counts[:total] += 1
        @counts[:ends_sentence] += 1 if word_instance.ends_sentence?
      end

      def push(next_word)
        # Also add the follwoing word
        @next_words << next_word.to_s
      end

      def next_word
        next_words.sample
      end

      def ==(other)
        other &&
          self.word == other.word &&
          self.next_words == other.next_words
      end

      def occurrences
        counts[:total]
      end

      def likelihood_to_end_sentence
        # if we don't have enough data, we don't have enough data
        if occurrences >= SIGNIFICANT_OCCURRENCE_THRESHOLD
          counts[:ends_sentence].to_f / occurrences
        end
      end

      def to_s
        word
      end

      protected

      # for equality checking and other usage
      attr_reader :next_words
    end
  end
end