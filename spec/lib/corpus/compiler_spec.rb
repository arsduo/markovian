require 'spec_helper'
require 'markovian/corpus/compiler'

module Markovian
  class Corpus
    RSpec.describe Compiler do
      let(:text) { "hello--there" }
      let(:compiler) { Compiler.new }
      let(:corpus) { compiler.corpus }

      describe "#initialization" do
        it "can accept an existing corpus" do
          compiler.incorporate_text_into_corpus(text)
          new_corpus = Compiler.new(compiler.corpus).corpus
          expect(new_corpus.next_word("hello")).to eq("there")
        end
      end

      describe "#build_corpus" do
        it "will build_corpus multiple texts" do
          compiler.build_corpus([text, "there now"])
          expect(corpus.next_word("hello")).to eq("there")
          expect(corpus.next_word("there")).to eq("now")
        end
      end

      describe "#incorporate_text_into_corpus" do
        it "incorporates the split text going forward" do
          compiler.incorporate_text_into_corpus(text)
          expect(corpus.next_word("hello")).to eq("there")
        end

        it "incorporates the split text going backward" do
          compiler.incorporate_text_into_corpus(text)
          expect(corpus.previous_word("there")).to eq("hello")
        end

        it "will build on an existing corpus" do
          compiler.incorporate_text_into_corpus(text)
          compiler.incorporate_text_into_corpus("there now")
          expect(corpus.next_word("there")).to eq("now")
        end
      end
    end
  end
end
