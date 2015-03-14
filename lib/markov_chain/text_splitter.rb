module MarkovChain
  class TextSplitter
    attr_reader :text
    def initialize(text)
      @text = text
    end

    # word delimiters -- spaces, quotes, (dots, dashes, or colons -- semi or otherwise -- followed
    # by either another dash, a space, another dot, or the end of the text), or (colons preceded by
    # space or the beginning of the text). we don't want to block things like Jones-Smith, tl;dr,
    # abc.def, or it's.
    WORD_DELIMITERS = /(\s|"|[\.-:;]([-\.\s]|$)|[\s^]')/

    # anything that doesn't contain any letters or numbers is not a word we need to care about
    MARKERS_OF_INTEREST = /[A-Za-z0-9]/

    def components
      split_text.select {|t| t.match(MARKERS_OF_INTEREST)}
    end

    protected

    def split_text
      text.downcase.split(WORD_DELIMITERS)
    end
  end
end
