require 'spec_helper'

module Markovian
  RSpec.describe TextBuilder do
    let(:seed_text) { "going on" }
    let(:chain_set) { double("ChainSet") }
    let(:builder) { TextBuilder.new(seed_text, chain_set) }

    describe "#construct" do
      let(:stream_of_words) {
        [
          "going", "on", "voluptate", "debitis", "rerum", "recusandae", "accusantium", "quo",
          "consequatur", "quam", "hic", "atque", "earum", "repellendus", "quasi", "est", "aut",
          "omnis", "eum", "numquam", "distinctio"
        ]
      }

      before :each do
        # freeze randomness
        srand 17
        allow(chain_set).to receive(:next_word) do |current_word, previous_word:|
          # simple mechanism to the next word
          if current_index = stream_of_words.index(current_word)
            # since the stream is purely linear, we can also ensure that we're calling the words in
            # the right sequence
            if current_index == 0
              expect(previous_word).to be_nil
            else
              expect(previous_word).to eq(stream_of_words[current_index - 1])
            end
          end
          stream_of_words[current_index.to_i + 1]
        end
      end

      it "builds a text of the right length" do
        expect(builder.construct).to eq("voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam distinctio")
      end

      it "accepts a shorter length" do
        expect(builder.construct(length: 20)).to eq("voluptate debitis")
      end

      it "will accept a different seed" do
        allow(chain_set).to receive(:next_word) do |current_word, previous_word|
          # we have to skip the check for previous word now, since we're messing with the start
          # point (and our mock is simple)
          stream_of_words[stream_of_words.index(current_word).to_i + 1]
        end

        expect(builder.construct(seed: "voluptate")).to eq("on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end

      it "includes the seed word if desired" do
        expect(builder.construct(start_result_with_seed_word: true)).to eq("going on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end

      it "ignores leading spaces" do
        stream_of_words[3] = " foo "
        expect(builder.construct).to eq("voluptate foo rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam distinctio")
      end

      it "works fine if there's only one word in the seed text" do
        builder = TextBuilder.new("going", chain_set)
        expect(builder.construct).to eq("on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end
    end

    describe "#default_seed" do
      context "if the seed has multiple words" do
        it "returns the last two items" do
          expect(builder.default_seed).to eq(["going", "on"])
        end
      end

      context "if the seed is only one word" do
        let(:seed_text) { "result " }

        it "returns [nil, the_word]" do
          expect(builder.default_seed).to eq([nil, "result"])
        end
      end
    end
  end
end
