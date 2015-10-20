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
> chain = Markovian::Chain.new
> chain.lengthen("there", next_word: "friend")
> chain.lengthen("there", next_word: "are")
> chain.lengthen("are", next_word: "four", previous_word: "four")
> chain.lengthen("four", next_word: "lights", previous_word: "four")
> chain.lengthen("are", next_word: "we")
> chain.lengthen("friend", next_word: "cat")
> chain.lengthen("cat", next_word: "rocks", previous_word: "friend")
# Now, we can build some text!
> Markovian::TextBuilder.new(chain).construct("there")
=> "there friend cat rocks"
```

Exactly!

Markovian is most easily used with the [markovian-tools
gem](https://github.com/arsduo/markovian-tools), which provides utilities for importing
Twitter and Facebook archives and for posting tweets, among other things.

## Features

So far, Markovian gives you the ability to, given a set of inputs, generate random text. In
addition, your money gets you:

* A built-in filter to remove final words that statistically (in the corpus) rarely end sentences.
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
