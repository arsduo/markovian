# CHANGELOG

## 0.4.0

* Extract SentenceBuilder from TextBuilder for future use
* Chain#lengthen can now take strings as well as Tokeneyes::Words
* Fix bug preventing reuse of TextBuilder objects
* EndOfSentenceFilter can now handle sentences where no word meets the criteria
* EndOfSentenceFilter now strips as many words as shouldn't be there
* Bumped up the significant occurrence threshold for filtering to 500 occurrences
* Handle edge cases of words that always end sentences

## 0.3.0

* TextBuilder now filters out final words that statistically rarely end sentences (first filter!)
* TextBuilder#construct now includes seed text by default (instead of via opt-in)
* Add Chain#word_entry to allow access to word data
* Properly collect metadata about words (previously collected next_word's data)
* Refactor Dictionary to provide access to entries, removing a lot of method duplication
* Remove Corpus class (no longer necessary), make Chain the base

## 0.2.9

Internal refactors only, no new functionality.

* Refactor Dictionary to use DictionaryEntry objects, which can store additional metadata
* Use Tokeneyes to parse strings rather than the original String#split-based TextSplitter

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
