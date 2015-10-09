module Markovian
  class TextBuilder
    # This class will take sentence and apply appropriate filters. It will roll back a sentence up
    # to a certain number of words if those words have a low likelihood of ending the sentence.
    # Future changes will increase the qualities filtered for.
    class EndOfSentenceFilter
      MAX_WORDS_FILTERED = 3

      def filtered_sentence(sentence)
        filter_unlikely_ending_words(sentence)
      end

      protected

      def filter_unlikely_ending_words(current_sentence, words_filtered = 0)
        return current_sentence if words_filtered >= MAX_WORDS_FILTERED

        last_word = current_sentence.last
        likelihood = last_word.likelihood_to_end_sentence
        if likelihood && rand < likelihood
          # if we pop a word, consider removing the next one
          filter_unlikely_ending_words(current_sentence[0..-2], words_filtered + 1)
        else
          # if this word hasn't been seen enough, allow it to end a sentence
          current_sentence
        end
      end
    end
  end
end

