require 'markovian/utils/text_splitter'
require 'markovian/text_builder/sentence_builder'
require 'markovian/text_builder/end_of_sentence_filter'

# This class, given a Markov chain, will attempt to construct a new text based on a given seed using
# the Markov associations.
module Markovian
  class TextBuilder
    attr_reader :chain
    def initialize(chain)
      @chain = chain
    end

    def construct(seed_text, length: 140, exclude_seed_text: false)
      sentence_builder = SentenceBuilder.new(chain: chain, max_length: length, seed_text: seed_text)
      output = sentence_builder.construct_sentence(exclude_seed_text)
      format_output(apply_filters(output))
    end

    protected

    def apply_filters(output)
      EndOfSentenceFilter.new.filtered_sentence(sentence_with_word_data(output))
    end

    # Turn an array of Word objects into an ongoing string
    def format_output(array_of_words)
      array_of_words.compact.map(&:to_s).map(&:strip).join(" ")
    end

    def sentence_with_word_data(sentence)
      sentence.map {|word| chain.word_entry(word)}
    end

    def sentence_builder
      @sentence_builder ||= SentenceBuilder.new(chain)
    end
  end
end
