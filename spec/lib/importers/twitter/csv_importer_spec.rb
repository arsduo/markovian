require 'spec_helper'
require 'markovian/importers/twitter/csv_importer'

module Markovian
  module Importers
    module Twitter
      RSpec.describe CsvImporter do
        let(:twitter_csv_path) { File.join(SPEC_ROOT, "fixtures/importers/twitter", "sample.csv")}
        let(:texts_in_csv) { [
          "My cats escaped into part of the church being used for Sunday school; getting them back into the theater made me miss a critical moment.",
          "I dreamt I couldn’t stop my car because a radon leak kept causing it to accelerate. Later, cat wrangling.",
          "@Lenary come back and visit Chicago! Or see SF. But Chicago's better as long as it's not winter :)"
        ] }
        let(:importer) { CsvImporter.new(twitter_csv_path) }

        describe "#corpus" do
          it "creates a corpus with the texts from the CSV" do
            expect(importer.corpus).to eq(Corpus::Compiler.new.build_corpus(texts_in_csv))
          end
        end

        describe "#texts_for_markov_analysis" do
          let(:texts) { importer.texts_for_markov_analysis }

          it "returns the relevant text, without any RTs or empty tweets" do
            expect(texts).to match_array(texts_in_csv)
          end
        end
      end
    end
  end
end
