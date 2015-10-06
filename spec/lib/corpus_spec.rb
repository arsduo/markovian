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

    describe "#random_word" do
      it "asks the one-key dictionary for a random word" do
        result = double("random word")
        allow(corpus.forward).to receive(:random_word).and_return(result)
        expect(corpus.random_word).to eq(result)
      end
    end

    describe "#==" do
      let(:other_corpus) { Corpus.new }
      let(:word) { Faker::Lorem.word }
      let(:other_word) { Faker::Lorem.word }

      it "returns true if they're both the same" do
        corpus.forward.lengthen(other_word, next_word: word)
        corpus.backward.lengthen(word, next_word: other_word)
        other_corpus.forward.lengthen(other_word, next_word: word)
        other_corpus.backward.lengthen(word, next_word: other_word)
        expect(corpus).to eq(other_corpus)
      end

      it "is order agnostic" do
        corpus.forward.lengthen(other_word, next_word: word)
        corpus.backward.lengthen(word, next_word: other_word)
        other_corpus.backward.lengthen(word, next_word: other_word)
        other_corpus.forward.lengthen(other_word, next_word: word)
        expect(corpus).to eq(other_corpus)
      end

      it "returns false if they're not both the same" do
        corpus.forward.lengthen(other_word, next_word: word)
        corpus.backward.lengthen(word, next_word: other_word)
        other_corpus.forward.lengthen(other_word, next_word: word)
        expect(corpus).not_to eq(other_corpus)
      end
    end
  end
end
