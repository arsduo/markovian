require 'spec_helper'

module Markovian
  class Corpus
    RSpec.describe Chain do
      let(:chain) { Chain.new }
      let(:word) { Tokeneyes::Word.new(Faker::Lorem.word) }
      let(:next_word) { Tokeneyes::Word.new(Faker::Lorem.word) }
      let(:previous_word) { Tokeneyes::Word.new(Faker::Lorem.word) }
      let(:phrase_association) { Tokeneyes::Word.new(Faker::Lorem.word) }

      describe "#next_word" do
        it "returns no values when empty" do
          expect(chain.next_word(word)).to be_nil
        end

        context "when populated" do
          context "with a single-word match" do
            before :each do
              chain.lengthen(word, next_word: next_word)
            end

            it "returns the next word when looking up by word" do
              expect(chain.next_word(word)).to eq(next_word.to_s)
            end

            it "returns the next word when looking up by phrase" do
              expect(chain.next_word(word, previous_word: previous_word)).to eq(next_word.to_s)
            end
          end

          context "with a phrase match and a single word match" do
            before :each do
              chain.lengthen(word, next_word: next_word)
              chain.lengthen(word, previous_word: previous_word, next_word: phrase_association)
            end

            it "samples the results when given a single word", temporary_srand: 12 do
              # jruby's srand returns something slightly different from MRI's, so we need to
              # hard-code two results
              if RUBY_PLATFORM == "java"
                results = [
                  next_word, phrase_association, phrase_association, next_word, phrase_association, next_word, next_word
                ]
              else
                results = [
                  next_word, phrase_association, phrase_association, next_word, next_word, next_word, phrase_association
                ]
              end
              expect(7.times.map { chain.next_word(word) }).to eq(results.map(&:to_s))
            end

            it "returns only the next match when looking up by phrase" do
              expect(7.times.map { chain.next_word(word, previous_word: previous_word) }).to eq([phrase_association.to_s] * 7)
            end
          end

          context "with only a phrase match" do
            before :each do
              chain.lengthen(word, previous_word: previous_word, next_word: phrase_association)
            end

            it "returns only the next phrase match when looking up by word" do
              expect(7.times.map { chain.next_word(word) }).to eq([phrase_association.to_s] * 7)
            end

            it "returns only the next match when looking up by phrase" do
              expect(7.times.map { chain.next_word(word, previous_word: previous_word) }).to eq([phrase_association.to_s] * 7)
            end
          end
        end
      end

      describe "#random_word" do
        it "asks the one-key dictionary for a random word", temporary_srand: 35 do
          chain.lengthen(word, next_word: next_word)
          chain.lengthen(next_word, next_word: word)
          if RUBY_PLATFORM == "java"
            expect(3.times.map { chain.random_word }).to eq([word, word, next_word].to_s)
          else
            expect(3.times.map { chain.random_word }).to eq([word, next_word, next_word].map(&:to_s))
          end
        end
      end

      describe "#==" do
        let(:other_chain) { Chain.new }

        it "returns true if they're the same" do
          chain.lengthen(word, next_word: next_word)
          chain.lengthen(next_word, next_word: word)
          other_chain.lengthen(word, next_word: next_word)
          other_chain.lengthen(next_word, next_word: word)
          expect(chain).to eq(other_chain)
        end

        it "is order agnostic" do
          chain.lengthen(word, next_word: next_word)
          chain.lengthen(next_word, next_word: word)
          other_chain.lengthen(next_word, next_word: word)
          other_chain.lengthen(word, next_word: next_word)
          expect(chain).to eq(other_chain)
        end

        it "returns false if they're not the same" do
          chain.lengthen(word, next_word: next_word)
          chain.lengthen(next_word, next_word: word)
          other_chain.lengthen(word, next_word: next_word)
          expect(chain).not_to eq(other_chain)
        end
      end
    end
  end
end
