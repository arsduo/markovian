require 'spec_helper'
require 'markovian/chain/text_compiler'

module Markovian
  class Chain
    RSpec.describe TextCompiler do
      let(:text) { "hello-there" }
      let(:text_compiler) { TextCompiler.new(text) }
      let(:chainset) { text_compiler.chainset }

      describe "#incorporate_into_chain" do
        it "incorporates the split text going forward" do
          text_compiler.incorporate_into_chain
          expect(chainset.next_word("hello")).to eq("there")
        end

        it "incorporates the split text going backward" do
          text_compiler.incorporate_into_chain
          expect(chainset.previous_word("there")).to eq("hello")
        end

        it "will build on an existing chainset" do
          text_compiler.incorporate_into_chain
          new_compiler = TextCompiler.new("there now", chainset)
          new_chainset = new_compiler.incorporate_into_chain
          expect(new_chainset.next_word("there")).to eq("now")
        end
      end
    end
  end
end
