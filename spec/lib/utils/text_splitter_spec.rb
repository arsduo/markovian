require 'spec_helper'

module Markovian
  module Utils
    RSpec.describe TextSplitter do
      describe "#components" do
        shared_examples_for :splitting_text do
          it "downcases and splits the text properly" do
            expect(TextSplitter.new(text).components.map(&:to_s)).to eq(result)
          end
        end

        context "when the text is straightforward" do
          let(:text) { "hello I am writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has a period in it" do
          let(:text) { "hello I am. writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has a period with no space" do
          let(:text) { "hello I am.writing code" }
          let(:result) { ["hello", "i", "am.writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has a colon with a space" do
          let(:text) { "hello I am: writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has some quotes" do
          let(:text) { "hello I \"am\" writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has some leading punctuation" do
          let(:text) { ".hello I am writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has some leading punctuation and a twitter mention" do
          let(:text) { ".@hello I am writing code" }
          let(:result) { ["@hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has a twitter mention" do
          let(:text) { "hello I am @writing code" }
          let(:result) { ["hello", "i", "am", "@writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when a word in the text has a dash" do
          let(:text) { "hello I am wr-iting code" }
          let(:result) { ["hello", "i", "am", "wr-iting", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has an interior dash" do
          let(:text) { "hello I am - writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has an interior double dash" do
          let(:text) { "hello I am--writing code" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has an apostrophe in a word" do
          let(:text) { "hello I am w'riting code" }
          let(:result) { ["hello", "i", "am", "w'riting", "code"] }

          it_should_behave_like :splitting_text
        end

        context "when the text has a dash at the end" do
          let(:text) { "hello I am writing code-" }
          let(:result) { ["hello", "i", "am", "writing", "code"] }

          it_should_behave_like :splitting_text
        end
      end
    end
  end
end
