require 'spec_helper'

module Markovian
  class Corpus
    class Chain
      RSpec.describe DictionaryEntry do
        let(:word) { Faker::Lorem.word }
        let(:entry) { DictionaryEntry.new(word) }
        let(:next_word) { Tokeneyes::Word.new(Faker::Lorem.word) }
        let(:other_word) { Tokeneyes::Word.new(Faker::Lorem.word) }

        it "initializes the occurrences to 0" do
          expect(entry.occurrences).to eq(0)
        end

        describe "pushing and retrieving words" do
          it "raises an error if the direction is invalid" do
            expect { entry.push(next_word, direction: :sideways) }.to raise_exception(ArgumentError)
          end

          context "going forward (the default)" do
            it "returns the next word if desired" do
              # since there's only one word it'll always return the same value
              entry.push(next_word)
              expect(entry.next_word).to eq(next_word.to_s)
            end

            it "doesn't populate the previous entries" do
              entry.push(next_word)
              expect(entry.previous_word).to be_nil
            end

            it "increases the occurence count" do
              expect { 3.times { entry.push(next_word) } }.to change { entry.occurrences }.from(0).to(3)
            end

            it "increases the ends_sentence count if appropriate" do
              entry.push(next_word)
              next_word.ends_sentence = true
              entry.push(next_word)
              expect(entry.counts[:ends_sentence]).to eq(1)
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

          context "going backward" do
            it "returns the next word if desired" do
              # since there's only one word it'll always return the same value
              entry.push(next_word, direction: :backwards)
              expect(entry.previous_word).to eq(next_word.to_s)
            end

            it "doesn't populate the forward entries" do
              entry.push(next_word, direction: :backwards)
              expect(entry.next_word).to be_nil
            end

            it "doesn't increase the seen count" do
              expect { 3.times { entry.push(next_word, direction: :backwards) } }.not_to change { entry.occurrences }
            end

            it "doesn't increase the ends_sentence count" do
              entry.push(next_word, direction: :backwards)
              next_word.ends_sentence = true
              entry.push(next_word, direction: :backwards)
              expect(entry.counts[:ends_sentence]).to eq(0)
            end

            it "samples from the entered words", temporary_srand: 17 do
              # fix the order of sampling so we can reproduce the test
              entry.push(next_word, direction: :backwards)
              entry.push(other_word, direction: :backwards)
              if RUBY_PLATFORM == "java"
                result = [next_word, other_word, other_word, other_word, other_word, next_word, next_word]
              else
                result = [next_word, next_word, other_word, next_word, other_word, next_word, other_word]
              end
              expect(7.times.map { entry.previous_word }).to eq(result.map(&:to_s))
            end
          end
        end

        describe "#==" do
          it "is equal if the word and both directions are the same" do
            entry.push(next_word)
            entry.push(other_word, direction: :backwards)
            other_entry = DictionaryEntry.new(word)
            other_entry.push(next_word)
            other_entry.push(other_word, direction: :backwards)
            expect(entry).to eq(other_entry)
          end

          it "is not equal if the base word is different" do
            entry.push(next_word)
            entry.push(other_word, direction: :backwards)
            other_entry = DictionaryEntry.new(Faker::Lorem.word)
            other_entry.push(next_word)
            other_entry.push(other_word, direction: :backwards)
            expect(entry).not_to eq(other_entry)
          end

          it "is not equal if the forward direction is different" do
            entry.push(next_word)
            entry.push(other_word, direction: :backwards)
            other_entry = DictionaryEntry.new(word)
            other_entry.push(Tokeneyes::Word.new(Faker::Lorem.word))
            other_entry.push(other_word, direction: :backwards)
            expect(entry).not_to eq(other_entry)
          end

          it "is not equal if the backward direction is different" do
            entry.push(next_word)
            entry.push(other_word, direction: :backwards)
            other_entry = DictionaryEntry.new(word)
            other_entry.push(next_word)
            other_entry.push(Tokeneyes::Word.new(other_word.to_s + "foo"), direction: :backwards)
            expect(entry).not_to eq(other_entry)
          end
        end

        describe "#likelihood_to_end_sentence" do
          it "returns nil if it has too few entries" do
            next_word.ends_sentence = true
            (DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD - 1).times do
              entry.push(next_word)
            end
            expect(entry.likelihood_to_end_sentence).to be_nil
          end

          it "returns % ending sentence if there's enough value" do
            times_not_ending = (DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD * 0.4).to_i
            times_not_ending.times do
              entry.push(next_word)
            end
            next_word.ends_sentence = true
            (DictionaryEntry::SIGNIFICANT_OCCURRENCE_THRESHOLD - times_not_ending).times do
              entry.push(next_word)
            end
            expect(entry.likelihood_to_end_sentence).to eq(0.6)
          end
        end
      end
    end
  end
end
