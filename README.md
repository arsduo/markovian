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
> tweets = importer.texts_for_markov_analysis; puts tweets.count
14394
 => nil

# Create a Chainset (the structure holding all the word relations)...
> chainset = Markovian::ChainSet.new
 => #<Markovian::ChainSet:0x007fd0ca03df70 ...>
# And add all the tweets to the Markov dictionary
> tweets.each {|t| Markovian::Chain::TextCompiler.new(t, chainset).incorporate_into_chain}; puts "done."
done.
 => nil

# Now, we can build some text!
> Markovian::TextBuilder.new("markov", chainset).construct
=> "markov chains a lot better than a month, i've been here half an hour of night when you can get behind belgium for the offline train journey"
```

Exactly!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arsduo/markovian. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

