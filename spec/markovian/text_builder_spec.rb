require 'spec_helper'

module Markovian
  RSpec.describe TextBuilder do
    let(:seed_text) { "going on" }
    let(:chain) { double("Chain") }
    let(:builder) { TextBuilder.new(chain) }

    describe "#construct", temporary_srand: 17 do
      let(:results) { Faker::Lorem.words(5) }
      let(:length) { 30 }
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

      it "returns the results of the SentenceBuilder call joined together" do
        expect(builder.construct(seed_text)).to eq(results.join(" "))
      end

      context "with a different length" do
        let(:length) { 30 }

        it "passes the other length through" do
          # verify that the assertion in the before filter still passes
          expect(builder.construct(seed_text, length: length)).to eq(results.join(" "))
        end
      end

      it "accepts a shorter length" do
        expect(builder.construct(seed_text, length: 20)).to eq("going on voluptate")
      end

      it "excludes the original seed text if desired" do
        expect(builder.construct("going! on?", exclude_seed_text: true)).to eq("voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam distinctio")
      end

      it "ignores leading spaces" do
        stream_of_words[3] = " foo "
        expect(builder.construct(seed_text)).to eq("going on voluptate foo rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end

      it "works fine with if the same instance is called more than once", :skip_previous_word_validation do
        builder.construct("going")
        expect(builder.construct("on")).to eq("on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end

      it "works fine if there's only one word in the seed text" do
        expect(builder.construct("going")).to eq("going on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end

      it "applies the filter" do
        result = ["result", "words"]
        expect_any_instance_of(TextBuilder::EndOfSentenceFilter).to receive(:filtered_sentence) do |instance, words|
          expect(words.map(&:class).uniq).to eq([Chain::DictionaryEntry])
          expect(words.map(&:word).join(" ")).to eq("going on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
          result
        end
        expect(builder.construct("going")).to eq(result.join(" "))
      end
    end
  end
end