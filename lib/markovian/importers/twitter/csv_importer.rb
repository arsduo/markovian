require 'csv'
require 'markovian/importers/twitter/tweet'

# This class will import a Twitter archive CSV, returning a set of tweets suitable for importation
# into a Markovian chain.
module Markovian
  module Importers
    module Twitter
      class CsvImporter
        attr_reader :path
        def initialize(path)
          @path = path
        end

        def texts_for_markov_analysis
          # reject any blank tweets -- in our case, those with only a stripped-out URL
          tweet_enumerator.reject {|t| t.empty?}
        end

        def chain
          Chain::Compiler.new.build_chain(texts_for_markov_analysis)
        end

        protected

        def csv_enumerator
          # returns an iterator object that we can roll through
          # this does not actually start reading the file
          @csv_enumerator ||= CSV.open(path, headers: true).each
        end

        # an iterator over personal tweets (e.g. not RTs)
        # the lazy iterator allows us to add the condition without having to parse the entire file at
        # once (which could easily encounter tens of thousands of rows).
        def personal_tweet_enumerator
          csv_enumerator.select {|row| row["retweeted_status_id"].empty? }
        end

        def tweet_enumerator
          personal_tweet_enumerator.map do |row|
            Tweet.new(row["text"]).interesting_text
          end
        end
      end
    end
  end
end
