require 'markovian/corpus/dictionary_entry'
#
# This class represents a dictionary of words or phrases and the various words that can follow
# them. The key is an opaque value, which could represent either a single word or a phrase as desired.
module Markovian
  class Corpus
    class Dictionary
      def push(key, word, direction: :forwards)
        dictionary[key].push(word, direction: direction)
      end

      def next_word(key)
        dictionary[key].next_word
      end

      def previous_word(key)
        dictionary[key].previous_word
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
        # We have to set the value of the hash in the block, otherwise it doesn't actually seem to
        # get saved properly. Default hash values behave weirdly in general.
        @dictionary ||= Hash.new {|hash, key| hash[key] = DictionaryEntry.new(key)}
      end
    end
  end
end
