require 'spec_helper'

module Markovian
  RSpec.describe Chain do
    let(:chain) { Chain.new }
    let(:word) { Faker::Lorem.word }
    let(:previous_word) { Faker::Lorem.word }
    # IMO we don't need to test the random sampling here, since Dictionary provides that
    # functionality
    let(:phrase_association) { Faker::Lorem.word }
    let(:word_association) { Faker::Lorem.word }

    describe "#next_word/#lengthen" do
      it "returns no values when empty" do
        expect(chain.next_word(word)).to be_nil
      end

      context "when populated" do
        context "with a single-word match" do
          before :each do
            chain.lengthen(word, next_word: word_association)
          end

          it "returns the next word when looking up by word" do
            expect(chain.next_word(word)).to eq(word_association)
          end

          it "returns the next word when looking up by phrase" do
            expect(chain.next_word(word, previous_word: previous_word)).to eq(word_association)
          end
        end

        context "with a phrase match and a single word match" do
          before :each do
            chain.lengthen(word, next_word: word_association)
            chain.lengthen(word, previous_word: previous_word, next_word: phrase_association)
          end

          it "samples the results when given a single word", temporary_srand: 12 do
            # jruby's srand returns something slightly different from MRI's, so we need to
            # hard-code two results
            if RUBY_PLATFORM == "java"
              results = [
                word_association, phrase_association, phrase_association, word_association, phrase_association, word_association, word_association
              ]
            else
              results = [
                word_association, phrase_association, phrase_association, word_association, word_association, word_association, phrase_association
              ]
            end
            expect(7.times.map { chain.next_word(word) }).to eq(results)
          end

          it "returns only the next match when looking up by phrase" do
            expect(7.times.map { chain.next_word(word, previous_word: previous_word) }).to eq([phrase_association] * 7)
          end
        end

        context "with only a phrase match" do
          before :each do
            chain.lengthen(word, previous_word: previous_word, next_word: phrase_association)
          end

          it "returns only the next phrase match when looking up by word" do
            expect(7.times.map { chain.next_word(word) }).to eq([phrase_association] * 7)
          end

          it "returns only the next match when looking up by phrase" do
            expect(7.times.map { chain.next_word(word, previous_word: previous_word) }).to eq([phrase_association] * 7)
          end
        end
      end
    end
  end
end
