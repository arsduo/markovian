require 'spec_helper'
require 'markovian/corpus/text_compiler'

module Markovian
  class Corpus
    RSpec.describe TextCompiler do
      let(:text) { "hello--there" }
      let(:text_compiler) { TextCompiler.new(text) }
      let(:corpus) { text_compiler.corpus }

      describe "#incorporate_into_chain" do
        it "incorporates the split text going forward" do
          text_compiler.incorporate_into_chain
          expect(corpus.next_word("hello")).to eq("there")
        end

        it "incorporates the split text going backward" do
          text_compiler.incorporate_into_chain
          expect(corpus.previous_word("there")).to eq("hello")
        end

        it "will build on an existing corpus" do
          text_compiler.incorporate_into_chain
          new_compiler = TextCompiler.new("there now", corpus)
          new_corpus = new_compiler.incorporate_into_chain
          expect(new_corpus.next_word("there")).to eq("now")
        end
      end
    end
  end
end
