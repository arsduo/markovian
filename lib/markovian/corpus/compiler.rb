require 'markovian/utils/text_splitter'

# Given a piece of text, this class returns a hash of Markov results: two-word phrases (two by
# default) pointing to an array of historical next words.
#
# So, for instance, the phrase "Cats are cute, cats are annoying" would map to:
# {
#   "cats are" => [cute, annoying],
#   "are cute" => [cats],
#   "cute cats" => [are],
# }
#
# Notes:
# * Next words (in v1) are not unique, in order to represent weighting. There are definitely more
#   space-compact ways to do that, but that's left for future implementation.
# * Punctuation is for later.
# * Handling sentences or newlines is later -- I'm not sure the right way to do it.
# * Capitalization is deferred for later.
module Markovian
  class Corpus
    class Compiler
      # Pass in a text, and optionally an existing Markov chain to add data to. In many cases, you
      # may be building a chain using a set of smaller texts instead of one large texts (dialog,
      # for instance, or Twitter archives), and so may call this class repeatedly for elements of
      # the parent corpus.
      attr_reader :corpus
      def initialize(starter_corpus = Corpus.new)
        @corpus = starter_corpus
      end

      def build_corpus(texts)
        texts.each {|t| incorporate_text_into_corpus(t)}
        corpus
      end

      def incorporate_text_into_corpus(text)
        add_text_to_chain(split_into_components(text), forward_chain)
        # to assemble backward text, we just create a corpus with all the texts reversed
        # that allows us to see what words precede any given word
        add_text_to_chain(split_into_components(text).reverse, backward_chain)
        corpus
      end

      protected

      def forward_chain
        corpus.forward
      end

      def backward_chain
        corpus.backward
      end

      def add_text_to_chain(text_elements, chain)
        previous_word = nil
        text_elements.each_with_index do |word, index|
          # if we're not at the beginning or the end of the text -- e.g. we have a full triple
          if next_word = text_elements[index + 1]
            chain.lengthen(word, next_word: next_word, previous_word: previous_word)
          end
          previous_word = word
        end
      end

      def split_into_components(text)
        Utils::TextSplitter.new(text).components
      end
    end
  end
end
