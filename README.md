# Abrupt
[![Gem Version](https://badge.fury.io/rb/abrupt.svg)](http://badge.fury.io/rb/abrupt)
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

### Help
```shell
abrupt -h
  NAME:

    Abrupt

  DESCRIPTION:

    Automated Reasoning for Web Usability Problems

  COMMANDS:
        
    convert Converts and merges xml files to owl                
    crawl   Crawls a website [BETA!]            
    help    Display global or [command] help documentation      

  GLOBAL OPTIONS:
        
    -h, --help 
        Display help documentation
        
    -v, --version 
        Display version information
        
    -t, --trace 
        Display backtrace when an error occurs
          
  AUTHOR:

    Manuel Dudda <dudda@paij.com>
  
  SOURCE CODE:

    https://github.com/manuel84/abrupt  
```


### Example

For converting owl file from xml use: 

```shell
abrupt convert spec/fixtures/rikscha_Result_min.xml spec/fixtures/rikscha.ohneBilder.2013-04-30_2013-08-17_min.xml --output tmp/out.ttl --format turtle
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/abrupt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
