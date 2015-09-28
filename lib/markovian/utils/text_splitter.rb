require 'tokeneyes'

module Markovian
  module Utils
    class TextSplitter
      attr_reader :text
      def initialize(text)
        @text = text
      end

      # anything that doesn't contain any letters is not a word we need to care about
      MARKERS_OF_INTEREST = /[A-Za-z]/

      def components
        split_text.select {|w| w.text.match(MARKERS_OF_INTEREST)}
      end

      protected

      def split_text
        Tokeneyes::Tokenizer.new(text.downcase).parse_into_words
      end
    end
  end
end
