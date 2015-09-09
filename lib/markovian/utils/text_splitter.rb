module Markovian
  module Utils
    class TextSplitter
      attr_reader :text
      def initialize(text)
        @text = text
      end

      # We split on spaces, quotes, (various symbols followed by either another dash, a space,
      # another dot, or the end of the text), or (colons preceded by space or the beginning of the
      # text).
      # We don't want to block things like Jones-Smith, tl;dr, abc.def, or it's.
      # Any of the following:
      # [\s\(\)] - a space or parentheses on their own
      # " - a quote on its own
      # [\.-:;\?\!]([-\.\s]|$) - a period, dash, ?, or ! followed by a space, period, dash, or the
      #                          end of the word
      # [\s^]' - a single ' following a non-letter
      WORD_DELIMITERS = /([\s\(\)]|"|[\.\-:;\?\!]([\-\.\s]|$)|[\s^]')/

      # anything that doesn't contain any letters is not a word we need to care about
      MARKERS_OF_INTEREST = /[A-Za-z]/

      def components
        split_text.select {|t| t.match(MARKERS_OF_INTEREST)}
      end

      protected

      def split_text
        text.downcase.split(WORD_DELIMITERS)
      end
    end
  end
end
