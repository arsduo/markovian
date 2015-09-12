require 'spec_helper'

module Markovian
  class Corpus
    class Chain
      RSpec.describe Dictionary do
        let(:dictionary) { Dictionary.new }
        let(:phrase) { Faker::Company.bs }
        let(:word) { Faker::Lorem.word }
        let(:word2) { Faker::Lorem.word }

        describe "push/next_word" do
          it "returns the word for the phrase" do
            # since there's only one word it'll always return the one word
            dictionary.push(phrase, word)
            expect(dictionary.next_word(phrase)).to eq(word)
          end

          it "samples from the remaining words", temporary_srand: 17 do
            # fix the order of sampling so we can reproduce the test
            dictionary.push(phrase, word)
            dictionary.push(phrase, word2)
            if RUBY_PLATFORM == "java"
              result = [word2, word2, word2, word, word, word2, word]
            else
              result = [word, word2, word, word2, word, word2, word]
            end
            expect(7.times.map { dictionary.next_word(phrase) }).to eq(result)
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
      end
    end
  end
end
