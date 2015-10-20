require 'spec_helper'

module Markovian
  RSpec.describe TextBuilder do
    let(:seed_text) { "going on" }
    let(:chain) { double("Chain") }
    let(:builder) { TextBuilder.new(chain) }

    describe "#construct", temporary_srand: 17 do
      let(:stream_of_words) {
        [
          "going", "on", "voluptate", "debitis", "rerum", "recusandae", "accusantium", "quo",
          "consequatur", "quam", "hic", "atque", "earum", "repellendus", "quasi", "est", "aut",
          "omnis", "eum", "numquam", "distinctio"
        ]
      }

      before :each do |example|
        # freeze randomness
        # jruby on travis has some weirdness around the keyword arg, so we treat it as a hash in
        # the tests
        skip_previous_word_validation = example.metadata[:skip_previous_word_validation]
        allow(chain).to receive(:next_word) do |current_word, params = {}|
          # simple mechanism to the next word
          previous_word = params[:previous_word]
          if current_index = stream_of_words.index(current_word.to_s)
            # since the stream is purely linear, we can also ensure that we're calling the words in
            # the right sequence
            if skip_previous_word_validation
              # do nothing
            elsif current_index == 0
              expect(previous_word).to be_nil
            else
              expect(previous_word.to_s).to eq(stream_of_words[current_index - 1])
            end
          end
          stream_of_words[current_index.to_i + 1]
        end

        allow(chain).to receive(:word_entry) do |word|
          Markovian::Chain::DictionaryEntry.new(word)
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