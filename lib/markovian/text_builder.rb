require 'markovian/utils/text_splitter'

# This class, given a Markov corpus, will attempt to construct a new text based on a given seed using
# the Markov associations.
module Markovian
  class TextBuilder
    attr_reader :seed_text, :corpus
    def initialize(corpus)
      @corpus = corpus
    end

    def construct(seed_text, length: 140, start_result_with_seed: false)
      # TODO: if we don't hit a result for the first pair, move backward through the original text
      # until we get something
      seed_pair = identify_starter_text(seed_text)
      result_with_next_word(
        previous_pair: seed_pair,
        result: start_result_with_seed ? seed_text : nil,
        length: length
      )
    end

    def identify_starter_text(raw_text)
      seed_components = split_seed_text(raw_text)
      if seed_components.length >= 2
        seed_components[-2..-1]
      else
        # if we only have a one-word seed text, the previous word is nil
        [nil, seed_components.first]
      end
    end

    protected

    def result_with_next_word(previous_pair:, result:, length:)
      previous_word, current_word = previous_pair
      if next_word = corpus.next_word(current_word, previous_word: previous_word)
        # we use join rather than + to avoid leading spaces, and strip to ignore leading nils or
        # empty strings
        interim_result = format_result_array([result, next_word])
        if interim_result.length > length
          result
        else
          result_with_next_word(
            previous_pair: [current_word, next_word],
            result: interim_result,
            length: length
          )
        end
      else
        result
      end
    end

    # Turn an array of words into an ongoing string
    def format_result_array(array_of_words)
      array_of_words.compact.map(&:strip).join(" ")
    end

    def split_seed_text(seed_text)
      # We get back Tokeneyes::Word objects, but for now only care about the strings within
      Utils::TextSplitter.new(seed_text).components.map(&:to_s)
    end
  end
end
