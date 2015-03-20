require 'spec_helper'

module MarkovChain
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

      it "samples from the remaining words" do
        # fix the order of sampling so we can reproduce the test
        old_srand = srand
        srand 17
        dictionary.push(phrase, word)
        dictionary.push(phrase, word2)
        expect(7.times.map { dictionary.next_word(phrase) }).to eq([
          word, word2, word, word2, word, word2, word
        ])
        srand old_srand
      end
    end
  end
end
