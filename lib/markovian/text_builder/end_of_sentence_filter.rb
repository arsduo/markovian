module Markovian
  class TextBuilder
    # This class will take sentence and apply appropriate filters. It will roll back a sentence up
    # to a certain number of words if those words have a low likelihood of ending the sentence.
    # Future changes will increase the qualities filtered for.
    class EndOfSentenceFilter
      def filtered_sentence(sentence)
        filter_unlikely_ending_words(sentence)
      end

      protected

      def filter_unlikely_ending_words(current_sentence, words_filtered = 0)
        last_word = current_sentence.last
        if !last_word
          # None of the words merit ending the sentence! The caller will deal with how to handle
          # this situation.
          []
        elsif should_filter_out?(last_word)
          # if we pop a word, consider removing the next one
          filter_unlikely_ending_words(current_sentence[0..-2], words_filtered + 1)
        else
          # if this word hasn't been seen enough, allow it to end a sentence
          current_sentence
        end
      end

      def should_filter_out?(word)
        likelihood = word.likelihood_to_end_sentence
        # We filter words out that
        # a) have enough data to say whether they end sentences
        # b) do not always end the sentence AND
        # c1) either literally never end a sentence OR
        # c2) randomly fail a check based on how frequently they end stuff
        likelihood &&
          likelihood != 1 &&
          (likelihood == 0 || rand > word.likelihood_to_end_sentence)

      end
    end
  end
end

