require 'spec_helper'

module Markovian
  class Chain
    RSpec.describe DictionaryEntry do
      let(:word) { Faker::Lorem.word }
      let(:word_object) { Tokeneyes::Word.new(word) }
      let(:entry) { DictionaryEntry.new(word) }
      let(:next_word) { Tokeneyes::Word.new(Faker::Lorem.word) }
      let(:other_word) { Tokeneyes::Word.new(Faker::Lorem.word) }

      it "initializes the occurrences to 0" do
        expect(entry.occurrences).to eq(0)
      end

      describe "#record_observance" do
        it "raises an error if the direction is invalid" do
          expect { entry.push(word_object) }
        end

        it "increases the occurence count" do
          expect { 3.times { entry.record_observance(word_object) } }.to change { entry.occurrences }.from(0).to(3)
        end

        it "increases the ends_sentence count if appropriate" do
          entry.record_observance(word_object)
          word_object.ends_sentence = true
          entry.record_observance(word_object)
          expect(entry.counts[:ends_sentence]).to eq(1)
        end
      end

      describe "pushing and retrieving words" do
        it "returns the next word if desired" do
          # since there's only one word it'll always return the same value
          entry.push(next_word)
          expect(entry.next_word).to eq(next_word.to_s)
        end

        it "samples from the entered words", temporary_srand: 17 do
          # fix the order of sampling so we can reproduce the test
          entry.push(next_word)
          entry.push(other_word)
          if RUBY_PLATFORM == "java"
            result = [next_word, other_word, other_word, other_word, other_word, next_word, next_word]
          else
            result = [next_word, next_word, other_word, next_word, other_word, next_word, other_word]
          end
          expect(7.times.map { entry.next_word }).to eq(result.map(&:to_s))
        end
      end

      describe "#==" do
        it "is equal if the word and both directions are the same" do
          entry.push(next_word)
          entry.push(other_word)
          other_entry = DictionaryEntry.new(word)
          other_entry.push(next_word)
          other_entry.push(other_word)
          expect(entry).to eq(other_entry)
        end

        it "is not equal if the base word is different" do
          entry.push(next_word)
          entry.push(other_word)
          other_entry = DictionaryEntry.new(word + "Hello")
          other_entry.push(next_word)
          other_entry.push(other_word)
          expect(entry).not_to eq(other_entry)
        end

        it "is not equal if the transitions are different" do
          entry.push(next_word)
          entry.push(other_word)
          other_entry = DictionaryEntry.new(word)
          other_entry.push(Tokeneyes::Word.new(word + "Hello"))
          other_entry.push(other_word)
          expect(entry).not_to eq(other_entry)
        end

        it "is not equal to nil" do
          expect(entry).not_to eq(nil)
        end
      end

      describe "#likelihood_to_end_sentence" do
        it "returns nil if it has too few entries" do
          word_object.ends_sentence = true
          (DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD - 1).times do
            entry.record_observance(word_object)
          end
          expect(entry.likelihood_to_end_sentence).to be_nil
        end

        it "returns % ending sentence if there's enough value" do
          times_not_ending = (DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD * 0.4).to_i
          times_not_ending.times do
            entry.record_observance(word_object)
          end
          word_object.ends_sentence = true
          (DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD - times_not_ending).times do
            entry.record_observance(word_object)
          end
          expect(entry.likelihood_to_end_sentence).to eq(0.6)
        end
      end

      describe "#to_s" do
        it "returns the word" do
          expect(entry.to_s).to eq(word)
        end
      end
    end
  end
end
