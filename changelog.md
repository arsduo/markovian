# CHANGELOG

## 0.2.0

* Rename Chainset/Chain to Corpus (better name is better)
* Add Corpus#random_word to provide a starting place for texts
* Refactor Rename Corpus::TextCompiler into Corpus::Compiler
* Add equality operators for Corpus/Chain/Dictionary
* Add Twitter::CsvImporter.corpus convenience method
* TextBuilder has a better interface now
* Dictionary#inspect produces sane output, not the entire dictionary contents

## 0.1.0 and below

* Ability to build bidirectional corpuss (pair of chains) from arrays of texts
* Ability to import Twitter archives and produce an array of tweets
* Ability to generate Markovian texts from a corpus
* Gem framework
