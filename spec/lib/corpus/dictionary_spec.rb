require 'spec_helper'

module Markovian
  module Corpus
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
      end
    end
  end
end
