module MarkovChain
  RSpec.describe TextAnalyzer do
    let(:text) { "hello-there" }
    let(:text_analyzer) { TextAnalyzer.new(text) }
    let(:chainset) { text_analyzer.chainset }

    describe "#incorporate_into_chain" do
      it "incorporates the split text going forward" do
        text_analyzer.incorporate_into_chain
        expect(chainset.next_word("hello")).to eq("there")
      end

      it "incorporates the split text going backward" do
        text_analyzer.incorporate_into_chain
        expect(chainset.previous_word("there")).to eq("hello")
      end

      it "will build on an existing chainset" do
        text_analyzer.incorporate_into_chain
        new_analyzer = TextAnalyzer.new("there now", chainset)
        new_chainset = new_analyzer.incorporate_into_chain
        expect(new_chainset.next_word("there")).to eq("now")
      end
    end
  end
end
