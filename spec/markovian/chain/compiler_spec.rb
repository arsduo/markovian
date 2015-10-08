require 'spec_helper'
require 'markovian/chain/compiler'

module Markovian
  class Chain
    RSpec.describe Compiler do
      let(:text) { "hello--there" }
      let(:compiler) { Compiler.new }
      let(:chain) { compiler.chain }

      describe "#initialization" do
        it "can accept an existing chain" do
          compiler.incorporate_text_into_chain(text)
          new_chain = Compiler.new(compiler.chain).chain
          expect(new_chain.next_word("hello")).to eq("there")
        end
      end

      describe "#build_chain" do
        it "will incorporates multiple texts" do
          compiler.build_chain([text, "there now"])
          expect(chain.next_word("hello")).to eq("there")
          expect(chain.next_word("there")).to eq("now")
        end
      end

      describe "#incorporate_text_into_chain" do
        it "incorporates the split text" do
          compiler.incorporate_text_into_chain(text)
          expect(chain.next_word("hello")).to eq("there")
        end

        it "will build on an existing chain" do
          compiler.incorporate_text_into_chain(text)
          compiler.incorporate_text_into_chain("there now")
          expect(chain.next_word("there")).to eq("now")
        end
      end
    end
  end
end
