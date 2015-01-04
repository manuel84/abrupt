# Abrupt
[![Build Status](https://travis-ci.org/manuel84/abrupt.svg?branch=master)](https://travis-ci.org/manuel84/abrupt)
[![Code Climate](https://codeclimate.com/github/manuel84/abrupt/badges/gpa.svg)](https://codeclimate.com/github/manuel84/abrupt)
[![Test Coverage](https://codeclimate.com/github/manuel84/abrupt/badges/coverage.svg)](https://codeclimate.com/github/manuel84/abrupt)

Tools for the AbRUPt project, see [http://wba.cs.hs-rm.de/AbRUPt/service/](http://wba.cs.hs-rm.de/AbRUPt/service/)

## Installation

Add this line to your application's Gemfile:

    gem 'abrupt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install abrupt

## Usage

For converting owl file from xml use: 

```shell
abrupt convert spec/fixtures/rikscha_Result.xml spec/fixtures/rikscha.ohneBilder.2013-04-30_2013-08-17.xml > output.ttl
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/abrupt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
