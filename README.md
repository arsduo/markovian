[![Code Climate](https://codeclimate.com/github/arsduo/markovian/badges/gpa.svg)](https://codeclimate.com/github/arsduo/markovian)
[![Test Coverage](https://codeclimate.com/github/arsduo/markovian/badges/coverage.svg)](https://codeclimate.com/github/arsduo/markovian/coverage)
[![Build Status](https://travis-ci.org/arsduo/markovian.svg)](https://travis-ci.org/arsduo/markovian)

# A Markov Implementation

## Installation

Clone from Github, and then execute:

    $ bundle

## Usage

Fuller documentation will come shortly. For now, let's see how we can use Markovian to build some tweets from a Twitter archive we've downloaded:

```ruby
> path = #{path_to_twitter_archive}
 => path_to_twitter_archive
> importer = Markovian::Importers::Twitter::CsvImporter.new(path)
 => #<Markovian::Importers::Twitter::CsvImporter:0x007fd0ca3282a8 @path=path_to_twitter_archive>
# now assemble the chain based on the tweets -- this may take a few seconds to compile
> chain = importer.chain
 => #<Markovian::Corpus:0x007fd0ca03df70 ...>
# Now, we can build some text!
> Markovian::TextBuilder.new(chain).construct("markov")
=> "markov chains a lot better than a month, i've been here half an hour of night when you can get behind belgium for the offline train journey"
```

Exactly!

## Features

So far, Markovian gives you the ability to, given a set of inputs, generate random text. In
addition, your money gets you:

* A built-in importer to turn Twitter csv archives into Markov chain-derived text
* A built-in filter  to remove final words that statistically (in the corpus) rarely end sentences.
  Avoid unsightly sentences ending in "and so of" and so on!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Related Projects

* [tokeneyes](https://github.com/arsduo/tokeneyes): a tokenizing system used by Markovian that
  provides info on punctuation and sentence flow (to be incorporated shortly)
* [markovian-lambda](https://github.com/arsduo/markovian-lambda): an inchoate set of utility
  classes for using Markovian, eventually with AWS Lambda.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arsduo/markovian. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
