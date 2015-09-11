require 'spec_helper'

module Markovian
  RSpec.describe Corpus do
    let(:corpus) { Corpus.new }
    let(:forward) { corpus.forward }
    let(:backward) { corpus.backward }
    let(:word) { Faker::Lorem.word }
    let(:other_word) { Faker::Lorem.word }

    describe "#next_word" do
      it "calls the forward chain's next word" do
        expect(forward).to receive(:next_word).with(word, previous_word: other_word)
        corpus.next_word(word, previous_word: other_word)
      end

      it "defaults the previous word to nil if not provided" do
        expect(forward).to receive(:next_word).with(word, previous_word: nil)
        corpus.next_word(word)
      end
    end

    describe "#next_word" do
      it "calls the backward chain's next word" do
        expect(backward).to receive(:next_word).with(word, previous_word: other_word)
        corpus.previous_word(word, following_word: other_word)
      end

      it "defaults the following word to nil if not provided" do
        expect(backward).to receive(:next_word).with(word, previous_word: nil)
        corpus.previous_word(word)
      end
    end
  end
end
