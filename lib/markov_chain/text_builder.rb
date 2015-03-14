# This class, given a seed text and a dictionary, will attempt to construct a new text.
module MarkovChain
  class TextBuilder
    attr_reader :seed_text, :dictionary
    def initialize(seed_text, dictionary)
      @seed_text = seed_text
      @dictionary = dictionary
    end

    def construct(length: 140, seed: default_seed, start_with_seed: false)
      # TODO: if we don't hit a result for the first pair, move backward through the original text
      # until we get something
      result_with_next_word(
        previous_pair: seed,
        result: start_with_seed ? seed : "",
        length: length
      )
    end

    def default_seed
      split_seed_text[-2..-1]
    end

    protected

    def result_with_next_word(previous_pair:, result:, length:)
      previous_word, current_word = previous_pair
      if next_word = dictionary.next_word(current_word, previous_word: previous_word)
        interim_result = [result, next_word].join(" ") # join rather than + to avoid leading spaces
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
      @split_seed_text ||= TextSplitter.new(seed_text).components
    end
  end
end
