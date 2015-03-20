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
    # Pass in a text, and optionally a Markov chain to add data to. (If, for instance, you're
    # importing a text broken out into smaller lines -- dialog, for instance, or Twitter archives)
    # -- you may want to incorporate words across sentence or word boundaries, but not across
    # units.)
    attr_reader :text, :chain
    def initialize(text, starter_chain = Chain.new)
      @text = text
      @chain = starter_chain
    end

    def incorporate_into_chain
      previous_word = nil
      interesting_split_text.each_with_index do |word, index|
        # if we're not at the beginning or the end of the text -- e.g. we have a full triple
        if next_word = interesting_split_text[index + 1]
          chain.lengthen(word, next_word: next_word, previous_word: previous_word)
        end
        previous_word = word
      end
      chain
    end

    protected

    def interesting_split_text
      @interesting_split_text ||= TextSplitter.new(text).components
    end
  end
end


