module Importers
  module Twitter
    # Represents an individual tweet
    class Tweet
      attr_reader :text
      def initialize(text)
        @text = text
      end

      # Not currently used, but we might want to weight mentions later.
      def mentions
        text.scan(/(\@[a-z0-9_]+)/).flatten
      end

      def interesting_text
        without_urls(without_leading_dot(text))
      end

      protected

      # We don't want URLs to be considered inside our Markov machine.
      # URL matching is nearly impossible, but this regexp should be good enough: http://stackoverflow.com/questions/17733236/optimize-gruber-url-regex-for-javascript
      # Nowadays Twitter replaces URLS with their own link shortener, but historically that wasn't
      # always true.
      def without_urls(string)
        string.gsub(/\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)\S+(?:[^\s`!\[\]{};:'".,?«»“”‘’]))/i, "")
      end

      # Avoid dots used to trigger mentions
      def without_leading_dot(string)
        string.gsub(/^\.\@/, "@")
      end
    end
  end
end

