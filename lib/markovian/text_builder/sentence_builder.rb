module Markovian
  class TextBuilder
    class SentenceBuilder
      attr_reader :seed_text, :chain, :max_length
      def initialize(chain:, seed_text:, max_length:)
        @chain = chain
        @seed_text = seed_text
        @max_length = max_length
      end

      def construct_sentence(exclude_seed_text = false)
        seed_components = split_seed_text(seed_text)
        result = result_with_next_word(
          previous_pair: identify_starter_text(seed_components),
          result: exclude_seed_text ? [] : seed_components
        )
        # Return a set of strings, not Tokeneyes::Word objects
        result.map(&:to_s)
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

      def result_with_next_word(previous_pair:, result:)
        previous_word, current_word = previous_pair
        if next_word = chain.next_word(current_word, previous_word: previous_word)
          # we use join rather than + to avoid leading spaces, and strip to ignore leading nils or
          # empty strings
          interim_result = result + [next_word]
          if format_output(interim_result).length > max_length
            result
          else
            result_with_next_word(
              previous_pair: [current_word, next_word],
              result: interim_result
            )
          end
        else
          result
        end
      end

      def split_seed_text(seed_text)
        # We get back Tokeneyes::Word objects, but for now only care about the strings within
        Utils::TextSplitter.new(seed_text).components
      end

      # Turn an array of Word objects into an ongoing string
      def format_output(array_of_words)
        array_of_words.compact.map(&:to_s).map(&:strip).join(" ")
      end
    end
  end
end

