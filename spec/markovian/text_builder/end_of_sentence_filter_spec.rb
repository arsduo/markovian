require 'spec_helper'

module Markovian
  class TextBuilder
    RSpec.describe EndOfSentenceFilter do
      let(:filter) { EndOfSentenceFilter.new }

      describe "#filtered_sentence" do
        let(:raw_sentence) { 5.times.map { Faker::Lorem.word }  }
        let(:sentence) { raw_sentence.map {|word| Chain::DictionaryEntry.new(word) } }
        let(:significant_count) { Chain::DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD + 1 }

        def mark_how_ends_sentence(word, ends_sentence = false, count = significant_count)
          word_sighting = Tokeneyes::Word.new(word.word)
          word_sighting.ends_sentence = ends_sentence
          count.times do
            word.record_observance(word_sighting)
          end
        end

        it "does nothing to the sentence if the none of the last words have likelihoods" do
          sentence[0..1].each do |word|
            mark_how_ends_sentence(word, true)
          end
          expect(filter.filtered_sentence(sentence)).to eq(sentence)
        end

        it "does nothing if the words occur enough but don't end sentences" do
          sentence.each do |word|
            mark_how_ends_sentence(word)
          end
          expect(filter.filtered_sentence(sentence)).to eq(sentence)
        end

        it "will strip a words that never end sentences" do
          sentence.each_with_index do |word, index|
            mark_how_ends_sentence(word, index == 4)
          end
          expect(filter.filtered_sentence(sentence)).to eq(sentence[0..3])
        end

        it "ends if all words are stripped" do
          sentence.each do |word|
            mark_how_ends_sentence(word, true)
          end
          expect(filter.filtered_sentence(sentence)).to eq([])
        end

        it "applies a probability based on the word's likelihood to end the sentence", temporary_srand: 37 do
          proportion = (significant_count * 0.6).to_i
          mark_how_ends_sentence(sentence.last, true, proportion)
          mark_how_ends_sentence(sentence.last, false, significant_count - proportion)
          result = 10.times.map { filter.filtered_sentence(sentence)[4] }
          last_word = sentence.last
          if RUBY_PLATFORM == "java"
            expect(result).to eq([last_word, nil, last_word, nil, last_word, last_word, last_word, nil, last_word, last_word])
          else
            expect(result).to eq([nil, last_word, last_word, nil, last_word, nil, last_word, last_word, last_word, nil])
          end
        end
      end
    end
  end
end
