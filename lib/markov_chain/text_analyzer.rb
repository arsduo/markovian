# Given a text to analyze, this class returns a hash of Markov results: two-word phrases (two by
# default) pointing to an array of historical next words.
#
# So, for instance, the phrase "Cats are cute, cats are annoying" would map to:
# {
#   "cats are" => [cute, annoying],
#   "are cute" => [cats],
#   "cute cats" => [are],
# }
#
# Notes:
# * Next words (in v1) are not unique, in order to represent weighting. There are definitely more
#   space-compact ways to do that, but that's left for future implementation.
# * Punctuation is for later.
# * Handling sentences or newlines is later -- I'm not sure the right way to do it.
# * Capitalization is deferred for later.
module MarkovChain
  class TextAnalyzer
    # Pass in a text, and optionally a Markov dictionary to add data to. (If, for instance, you're
    # importing a text broken out into smaller lines -- dialog, for instance, or Twitter archives)
    # -- you may want to incorporate words across sentence or word boundaries, but not across
    # units.)
    attr_reader :text, :dictionary
    def initialize(text, starter_dictionary = ImportingDictionary.new)
      @text = text
      @dictionary = starter_dictionary
    end

    PHRASE_SIZE = 2
    WORD_DELIMITERS = /[\.\-\s]/

    def dictionary_for_text
      build_hash
      dictionary
    end

    protected

    # Go through the text, and assemble the hash
    def build_hash
      previous_word = nil
      split_text.each_with_index do |word, index|
        # if we're not at the beginning or the end of the text -- e.g. we have a full triple
        if previous_word && next_word = split_text[index + 1]
          dictionary.push(previous_word, word, next_word)
        end
        previous_word = word
      end
    end

    def split_text
      @split_text ||= text.downcase.split(WORD_DELIMITERS)
    end
  end
end


