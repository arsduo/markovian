module Markovian
  class Corpus
    class DictionaryEntry
      attr_reader :word, :counts
      def initialize(word)
        @word = word.to_s
        @next_words = []
        @previous_words = []
        @counts = Hash.new(0)
      end

      def record_observance(word_instance, direction: :forwards)
        # The word has been observed, so let's increase the appropriate counts.
        # We don't want to double-count words if we read the text both forward and backward, so
        # only count in the forward direction. (If we encounter a scenario where someone only wants
        # to read in the backward direction, we can deal with that then.)
        validate_direction(direction)
        if direction == :forwards
          @counts[:total] += 1
          @counts[:ends_sentence] += 1 if word_instance.ends_sentence?
        end
      end

      def push(next_word, direction: :forwards)
        # Also add the follwoing word
        array_for_direction(direction) << next_word.to_s
      end

      def next_word
        next_words.sample
      end

      def previous_word
        previous_words.sample
      end

      def ==(other)
        self.word == other.word &&
          self.next_words == other.next_words &&
          self.previous_words == other.previous_words
      end

      def occurrences
        counts[:total]
      end

      protected

      # for equality checking and other usage
      attr_reader :next_words, :previous_words

      VALID_DIRECTIONS = [:backwards, :forwards]

      def array_for_direction(direction)
        validate_direction(direction)
        direction == :backwards ? previous_words : next_words
      end

      def validate_direction(direction)
        unless VALID_DIRECTIONS.include?(direction)
          raise ArgumentError.new("Invalid direction #{direction.inspect}, valid directions are #{VALID_DIRECTIONS.inspect}")
        end
      end
    end
  end
end
