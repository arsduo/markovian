require 'markovian/utils/text_splitter'

# This class, given a seed word and a Markov chain_set, will attempt to construct a new text using
# the Markov associations.
module Markovian
  class TextBuilder
    attr_reader :seed_text, :chain_set
    def initialize(seed_text, chain_set)
      @seed_text = seed_text
      @chain_set = chain_set
    end

    def construct(length: 140, seed: default_seed, start_result_with_seed_word: false)
      # TODO: if we don't hit a result for the first pair, move backward through the original text
      # until we get something
      result_with_next_word(
        previous_pair: seed,
        result: start_result_with_seed_word ? seed : nil,
        length: length
      )
    end

    def default_seed
      if split_seed_text.length >= 2
        split_seed_text[-2..-1]
      else
        # if we only have a one-word seed text, the previous word is nil
        [nil, split_seed_text.first]
      end
    end

    protected

    def result_with_next_word(previous_pair:, result:, length:)
      previous_word, current_word = previous_pair
      if next_word = chain_set.next_word(current_word, previous_word: previous_word)
        #  we use join rather than + to avoid leading spaces, and compact to ignore leading nils
        interim_result = [result, next_word].compact.join(" ")
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

    def split_seed_text
      @split_seed_text ||= Utils::TextSplitter.new(seed_text).components
    end
  end
end
