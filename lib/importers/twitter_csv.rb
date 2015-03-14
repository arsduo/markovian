require 'csv'

module Importers
  class TwitterCSV
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
        string.gsub(/^\./, "")
      end
    end

    attr_reader :path
    def initialize(path)
      @path = path
    end

    def texts_for_markov_analysis
      # reject any blank tweets -- in our case, those with only a stripped-out URL
      tweet_enumerator.reject {|t| t.blank?}
    end

    protected

    def csv_enumerator
      # returns an iterator object that we can roll through
      # this does not actually start reading the file
      @csv_enumerator ||= CSV.open(path, headers: true).each.lazy
    end

    # an iterator over personal tweets (e.g. not RTs)
    # the lazy iterator allows us to add the condition without having to parse the entire file at
    # once (which could easily encounter tens of thousands of rows).
    def personal_tweet_enumerator
      csv_enumerator.reject {|row| row["retweeted_status_id"].present?}
    end

    def tweet_enumerator
      personal_tweet_enumerator.map do |row|
        Tweet.new(row["text"]).interesting_text
      end
    end
  end
end
