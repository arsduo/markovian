require 'spec_helper'

module Markovian
  class Corpus
    class Chain
      RSpec.describe Dictionary do
        let(:dictionary) { Dictionary.new }
        let(:phrase) { Faker::Company.bs }
        let(:word) { Faker::Lorem.word }
        let(:word2) { Faker::Lorem.word }

        describe "next_word" do
          it "pushes a word to the appropriate dictionary entry (forwards default)" do
            expect_any_instance_of(DictionaryEntry).to receive(:push).with(word2, direction: :forwards) do |entry|
              expect(entry.word).to eq(word)
            end
            dictionary.push(word, word2)
          end

          it "will push backwards if specified" do
            expect_any_instance_of(DictionaryEntry).to receive(:push).with(word2, direction: :backwards) do |entry|
              expect(entry.word).to eq(word)
            end
            dictionary.push(word, word2, direction: :backwards)
          end
        end

        describe "#next_word" do
          it "gets an appropriate word", temporary_srand: 21 do
            dictionary.push(phrase, word)
            dictionary.push(phrase, word2)
            expect(3.times.map { dictionary.next_word(phrase)}).to eq([word, word2, word])
          end
        end

        describe "#previous_word" do
          it "gets an appropriate word", temporary_srand: 21 do
            dictionary.push(phrase, word, direction: :backwards)
            dictionary.push(phrase, word2, direction: :backwards)
            expect(3.times.map { dictionary.previous_word(phrase)}).to eq([word, word2, word])
          end
        end

        describe "#random_word" do
          it "gets a random word from the dictionary", temporary_srand: 20 do
            dictionary.push(phrase, word)
            dictionary.push(word, word2)
            expect(3.times.map { dictionary.random_word }).to eq([word, phrase, word])
          end
        end

        describe "#==" do
          let(:other_dictionary) { Dictionary.new }

          it "returns true if they're both the same" do
            dictionary.push(phrase, word)
            dictionary.push(word, word2)
            other_dictionary.push(phrase, word)
            other_dictionary.push(word, word2)
            expect(dictionary).to eq(other_dictionary)
          end

          it "is order agnostic" do
            dictionary.push(phrase, word)
            dictionary.push(word, word2)
            other_dictionary.push(word, word2)
            other_dictionary.push(phrase, word)
            expect(dictionary).to eq(other_dictionary)
          end

          it "returns false if they're not both the same" do
            dictionary.push(phrase, word)
            dictionary.push(word, word2)
            other_dictionary.push(phrase, word)
            expect(dictionary).not_to eq(other_dictionary)
          end
        end

        describe "#inspect" do
          it "contains the entry count rather than the dictionary" do
            dictionary.push(phrase, word)
            dictionary.push(word, word2)
            expect(dictionary.inspect).to include("2 entries")
            expect(dictionary.inspect).not_to include(phrase)
            expect(dictionary.inspect).not_to include(word)
          end
        end
      end
    end
  end
end
