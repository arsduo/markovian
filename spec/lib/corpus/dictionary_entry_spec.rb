require 'spec_helper'

module Markovian
  class Corpus
    class Chain
      RSpec.describe DictionaryEntry do
        let(:word) { Faker::Lorem.word }
        let(:entry) { DictionaryEntry.new(word) }
        let(:next_word) { Faker::Lorem.word }
        let(:other_word) { Faker::Lorem.word }

        it "initializes the count to 0" do
          expect(entry.count).to eq(0)
        end

        describe "pushing and retrieving words" do
          context "going forward (the default)" do
            it "returns the next word if desired" do
              # since there's only one word it'll always return the same value
              entry.push(next_word)
              expect(entry.next_word).to eq(next_word)
            end

            it "doesn't populate the previous entries" do
              entry.push(next_word)
              expect(entry.previous_word).to be_nil
            end

            it "increases the seen count" do
              expect { 3.times { entry.push(next_word) } }.to change { entry.count }.from(0).to(3)
            end

            it "samples from the entered words", temporary_srand: 17 do
              # fix the order of sampling so we can reproduce the test
              entry.push(next_word)
              entry.push(other_word)
              if RUBY_PLATFORM == "java"
                result = [next_word, next_word, next_word, other_word, other_word, next_word, word]
              else
                result = [next_word, next_word, other_word, next_word, other_word, next_word, other_word]
              end
              expect(7.times.map { entry.next_word }).to eq(result)
            end
          end

          context "going backward" do
            it "returns the next word if desired" do
              # since there's only one word it'll always return the same value
              entry.push(next_word, direction: :backward)
              expect(entry.previous_word).to eq(next_word)
            end

            it "doesn't populate the forward entries" do
              entry.push(next_word, direction: :backward)
              expect(entry.next_word).to be_nil
            end

            it "doesn't increase the seen count" do
              expect { 3.times { entry.push(next_word, direction: :backward) } }.not_to change { entry.count }
            end

            it "samples from the entered words", temporary_srand: 17 do
              # fix the order of sampling so we can reproduce the test
              entry.push(next_word, direction: :backward)
              entry.push(other_word, direction: :backward)
              if RUBY_PLATFORM == "java"
                result = [next_word, next_word, next_word, other_word, other_word, next_word, word]
              else
                result = [next_word, next_word, other_word, next_word, other_word, next_word, other_word]
              end
              expect(7.times.map { entry.previous_word }).to eq(result)
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
            other_entry.push(Faker::Lorem.word)
            other_entry.push(other_word, direction: :backwards)
            expect(entry).not_to eq(other_entry)
          end

          it "is not equal if the backward direction is different" do
            entry.push(next_word)
            entry.push(other_word, direction: :backwards)
            other_entry = DictionaryEntry.new(word)
            other_entry.push(next_word)
            other_entry.push(Faker::Lorem.word, direction: :backwards)
            expect(entry).not_to eq(other_entry)
          end
        end
      end
    end
  end
end
