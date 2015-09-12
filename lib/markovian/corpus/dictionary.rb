# This class represents a dictionary of words or phrases and the various words that can follow
# them.  Currently it's implemented as a hash of arrays, but more advanced representations may
# follow.
#
# The key is an opaque value, which could represent either a single word or a phrase as desired.
module Markovian
  class Corpus
    class Dictionary
      def push(key, word)
        dictionary[key] += [word]
      end

      def next_word(key)
        dictionary[key].sample
      end

      def random_word
        dictionary.keys.sample
      end

      def ==(other)
        self.dictionary == other.dictionary
      end

      # We override this method to avoid spitting out every single element in the dictionary if
      # this (or any object containing it) gets inspected.
      # See http://stackoverflow.com/questions/5771339/emulate-default-objectinspect-output.
      def inspect
        "#<#{self.class}:0x#{__id__.to_s(16)} @dictionary: #{dictionary.length} entries>"
      end

      protected

      def dictionary
        @dictionary ||= Hash.new([])
      end
    end
  end
end
