require 'spec_helper'

module Markovian
  class Chain
    RSpec.describe Dictionary do
      let(:dictionary) { Dictionary.new }
      let(:phrase) { Tokeneyes::Word.new(Faker::Company.bs) }
      let(:word) { Tokeneyes::Word.new(Faker::Lorem.word) }
      let(:word2) { Tokeneyes::Word.new(Faker::Lorem.word) }

      describe "#[]" do
        it "returns an empty word entry if it doesn't exist yet" do
          expect(dictionary[word]).to eq(DictionaryEntry.new(word))
        end

        it "returns the existing entry if it exists" do
          entry = dictionary[word]
          entry.push(word2)
          other_entry = DictionaryEntry.new(word)
          other_entry.push(word2)
          expect(dictionary[word]).to eq(other_entry)
        end
      end

      describe "#random_word" do
        it "gets a random word from the dictionary", temporary_srand: 20 do
          dictionary[phrase]
          dictionary[word]
          expect(3.times.map { dictionary.random_word }).to eq([phrase, word, phrase].map(&:to_s))
        end
      end

      describe "#==" do
        let(:other_dictionary) { Dictionary.new }

        it "returns true if they're both the same" do
          dictionary[phrase].push(word)
          dictionary[word].push(word2)
          other_dictionary[phrase].push(word)
          other_dictionary[word].push(word2)
          expect(dictionary).to eq(other_dictionary)
        end

        it "is order agnostic" do
          dictionary[phrase].push(word)
          dictionary[word].push(word2)
          other_dictionary[word].push(word2)
          other_dictionary[phrase].push(word)
          expect(dictionary).to eq(other_dictionary)
        end

        it "returns false if they're not both the same" do
          dictionary[phrase].push(word)
          dictionary[word].push(word2)
          other_dictionary[phrase].push(word)
          expect(dictionary).not_to eq(other_dictionary)
        end
      end

      describe "#inspect" do
        it "contains the entry count rather than the dictionary" do
          dictionary[phrase].push(word)
          dictionary[word].push(word2)
          expect(dictionary.inspect).to include("2 entries")
          expect(dictionary.inspect).not_to include(phrase.to_s)
          expect(dictionary.inspect).not_to include(word.to_s)
        end
      end
    end
  end
end
