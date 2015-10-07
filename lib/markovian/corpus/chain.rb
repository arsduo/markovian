require 'markovian/corpus/dictionary'

# The Chain represents Markov info as it's being assembled or expanded from a text. To compensate
# for small sample sizes, we track multiple chains (derived from both two-word phrases and single
# word). Phrases are prefered, but if we can't find a match, we'll try with a single word.
module Markovian
  class Corpus
    class Chain
      def initialize
        @one_key_dictionary = Dictionary.new
        @two_key_dictionary = Dictionary.new
      end

      # Allow access to a word's metadata by providing its dictionary entry. For now, we only do
      # individual words, not two-word phrases.
      def word_entry(word)
        @one_key_dictionary[word]
      end

      def lengthen(word, next_word:, previous_word: nil)
        # When we encounter a word, we track its metadata and and what words surround it
        write_to_dictionary(@one_key_dictionary, word, word, next_word)
        write_to_dictionary(@two_key_dictionary, two_word_key(previous_word, word), word, next_word)
        word
      end

      def next_word(word, previous_word: nil)
        if dictionary_entry = entry(word, previous_word)
          dictionary_entry.next_word
        end
      end

      def random_word
        one_key_dictionary.random_word
      end

      def ==(other)
        self.one_key_dictionary == other.one_key_dictionary &&
          self.two_key_dictionary == other.two_key_dictionary
      end

      protected

      # for equality checking
      attr_reader :one_key_dictionary, :two_key_dictionary

      def entry(word, previous_word = nil)
        if previous_word
          entry_for_two_words(previous_word, word) || entry_for_one_word(word)
        else
          entry_for_one_word(word)
        end
      end

      def entry_for_two_words(previous_word, word)
        entry_if_present(@two_key_dictionary[two_word_key(previous_word, word)])
      end

      def entry_for_one_word(word)
        # Not strictly necessary, since if there's an empty entry here we'll just get nils, but better to
        # do it right.
        entry_if_present(@one_key_dictionary[word])
      end

      def entry_if_present(entry)
        # Ignore empty entries that haven't actually been seen in the corpus
        # TODO refactor to not even create them
        entry if entry.occurrences > 0
      end

      # We represent the two words as a space-delimited phrase for simplicity and speed of access via
      # hash keys.
      def two_word_key(word1, word2)
        "#{word1} #{word2}"
      end

      def write_to_dictionary(dictionary, key, word_instance, next_word)
        dictionary[key].record_observance(word_instance)
        dictionary[key].push(next_word)
      end
    end
  end
end
