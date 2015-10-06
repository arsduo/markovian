require 'spec_helper'

module Markovian
  RSpec.describe TextBuilder do
    let(:seed_text) { "going on" }
    let(:corpus) { double("Corpus::Corpus") }
    let(:builder) { TextBuilder.new(corpus) }

    describe "#construct", temporary_srand: 17 do
      let(:stream_of_words) {
        [
          "going", "on", "voluptate", "debitis", "rerum", "recusandae", "accusantium", "quo",
          "consequatur", "quam", "hic", "atque", "earum", "repellendus", "quasi", "est", "aut",
          "omnis", "eum", "numquam", "distinctio"
        ]
      }

      before :each do
        # freeze randomness
        # jruby on travis has some weirdness around the keyword arg, so we treat is as a hash in
        # the tests
        allow(corpus).to receive(:next_word) do |current_word, params = {}|
          # simple mechanism to the next word
          previous_word = params[:previous_word]
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
        expect(builder.construct(seed_text)).to eq("going on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
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

      it "works fine if there's only one word in the seed text" do
        expect(builder.construct("going")).to eq("going on voluptate debitis rerum recusandae accusantium quo consequatur quam hic atque earum repellendus quasi est aut omnis eum numquam")
      end
    end

    describe "#identify_starter_text" do
      context "if the seed has multiple words" do
        it "returns the last two items" do
          expect(builder.identify_starter_text(seed_text)).to eq(["going", "on"])
        end
      end

      context "if the seed is only one word" do
        it "returns [nil, the_word]" do
          expect(builder.identify_starter_text("result ")).to eq([nil, "result"])
        end
      end
    end
  end
end