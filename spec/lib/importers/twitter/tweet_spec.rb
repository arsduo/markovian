require 'spec_helper'
require 'markovian/importers/twitter/tweet'

module Markovian
  module Importers
    module Twitter
      RSpec.describe Tweet do
        let(:text) { ".@arsduo check out http://foo.com/?abc%D=3 check it out on @github" }
        let(:tweet) { Tweet.new(text) }

        describe "#mentions" do
          it "gets all the mentions in the text" do
            expect(tweet.mentions).to eq(["@arsduo", "@github"])
          end

          it "returns an empty array if there are no mentions" do
            expect(Tweet.new("hi there").mentions).to eq([])
          end
        end

        describe "#interesting_text" do
          context "if the text begins with a .@mention" do
            let(:text) { ".@arsduo hi!" }

            it "returns the text leading with " do
              expect(tweet.interesting_text).to eq("@arsduo hi!")
            end
          end

          context "if the text begins with a . but not a mention" do
            let(:text) { "...@arsduo wtf" }

            it "returns the text leading with " do
              expect(tweet.interesting_text).to eq("...@arsduo wtf")
            end
          end

          context "if the text has a URL" do
            it "returns the text leading with " do
              expect(tweet.interesting_text).to eq("@arsduo check out  check it out on @github")
            end
          end
        end
      end
    end
  end
end
