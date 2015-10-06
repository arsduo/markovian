require 'markovian/utils/text_splitter'

# This class, given a Markov corpus, will attempt to construct a new text based on a given seed using
# the Markov associations.
module Markovian
  class TextBuilder
    attr_reader :seed_text, :corpus
    def initialize(corpus)
      @corpus = corpus
    end

    def construct(seed_text, length: 140, exclude_seed_text: false)
      # TODO: if we don't hit a result for the first pair, move backward through the original text
      # until we get something
      seed_components = split_seed_text(seed_text)
      result_array = result_with_next_word(
        previous_pair: identify_starter_text(seed_components),
        result: exclude_seed_text ? [] : seed_components,
        length: length
      )
      format_result_array(result_array)
    end

    protected

    def identify_starter_text(seed_components)
      if seed_components.length >= 2
        seed_components[-2..-1]
      else
        # if we only have a one-word seed text, the previous word is nil
        [nil, seed_components.first]
      end
    end

    def result_with_next_word(previous_pair:, result:, length:)
      previous_word, current_word = previous_pair
      if next_word = corpus.next_word(current_word, previous_word: previous_word)
        # we use join rather than + to avoid leading spaces, and strip to ignore leading nils or
        # empty strings
        interim_result = result + [next_word]
        if format_result_array(interim_result).length > length
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

    # Turn an array of Word objects into an ongoing string
    def format_result_array(array_of_words)
      array_of_words.compact.map(&:to_s).map(&:strip).join(" ")
    end

    def split_seed_text(seed_text)
      # We get back Tokeneyes::Word objects, but for now only care about the strings within
      Utils::TextSplitter.new(seed_text).components
    end
    end
  end
end
