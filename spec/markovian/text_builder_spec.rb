require 'spec_helper'

module Markovian
  RSpec.describe TextBuilder do
    let(:seed_text) { "going on" }
    let(:chain) { double("Chain") }
    let(:builder) { TextBuilder.new(chain) }

    describe "#construct" do
      let(:results) { Faker::Lorem.words(5) }
      let(:length) { 140 }
      let(:exclude_seed_text) { false }

      before :each do
        allow(chain).to receive(:word_entry) do |word|
          Chain::DictionaryEntry.new(word)
        end

        allow_any_instance_of(TextBuilder::SentenceBuilder).to receive(:construct_sentence) do |instance, exclude_seed_text|
          expect(exclude_seed_text).to eq(exclude_seed_text)
          expect(instance.chain).to eq(chain)
          expect(instance.seed_text).to eq(seed_text)
          expect(instance.max_length).to eq(length)
          results
        end
      end

      it "returns the results of the SentenceBuilder call joined together up to 140 characters" do
        expect(builder.construct(seed_text)).to eq(results.join(" "))
      end

      context "with a different length" do
        let(:length) { 30 }

        it "passes the other length through" do
          # verify that the assertion in the before filter still passes
          expect(builder.construct(seed_text, length: length)).to eq(results.join(" "))
        end
      end

      it "applies the filter" do
        filter_result = ["result", "words"]
        expect_any_instance_of(TextBuilder::EndOfSentenceFilter).to receive(:filtered_sentence) do |instance, words|
          expect(words.map(&:class).uniq).to eq([Chain::DictionaryEntry])
          expect(words.map(&:word)).to eq(results)
          filter_result
        end
        expect(builder.construct(seed_text)).to eq(filter_result.join(" "))
      end
    end
  end
end