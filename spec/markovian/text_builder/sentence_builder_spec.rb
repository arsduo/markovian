require 'spec_helper'

module Markovian
  class TextBuilder
    RSpec.describe SentenceBuilder do
      let(:seed_text) { "going on" }
      let(:chain) { double("Chain") }
      let(:max_length) { 140 }
      let(:builder) {
        SentenceBuilder.new(chain: chain, seed_text: seed_text, max_length: max_length)
      }

      describe "#construct_sentence", temporary_srand: 17 do
        let(:stream_of_words) {
          [
            "going", "on", "voluptate", "debitis", "rerum", "recusandae", "accusantium", "quo",
            "consequatur", "quam", "hic", "atque", "earum", "repellendus", "quasi", "est", "aut",
            "omnis", "eum", "numquam", "distinctio"
          ]
        }
        let(:expected_result_at_default_length) { stream_of_words[0..-2] }

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
          expect(builder.construct_sentence.map(&:to_s)).to eq(expected_result_at_default_length)
        end

        it "ignores punctuation in the original seed text" do
          builder = SentenceBuilder.new(chain: chain, seed_text: "going? on!", max_length: max_length)
          expect(builder.construct_sentence).to eq(expected_result_at_default_length)
        end

        it "accepts a shorter length" do
          shorter_builder = SentenceBuilder.new(chain: chain, seed_text: seed_text, max_length: 20)
          expect(shorter_builder.construct_sentence).to eq(stream_of_words[0..2])
        end

        it "excludes the original seed text if desired" do
          expect(builder.construct_sentence(true)).to eq(stream_of_words[2..-1])
        end

        it "ignores leading spaces" do
          stream_of_words[3] = " foo "
          expect(builder.construct_sentence).to eq(expected_result_at_default_length)
        end

        it "works fine if there's only one word in the seed text" do
          builder_with_fewer_words = SentenceBuilder.new(chain: chain, seed_text: "going", max_length: max_length)
          expect(builder_with_fewer_words.construct_sentence).to eq(stream_of_words[0..-2])
        end
      end
    end
  end
end
