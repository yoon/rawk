# RawkLog

RawkLog - RAWK - Rail's Analyzer With Klass updated and packaged a Gem

This tool gives statistics for Ruby on Rails log files. The times for each request are grouped and totals are displayed. If process ids are present in the log files then requests are sorted by ActionController actions otherwise requests are grouped by url. By default total request times are used for comparison but database time or render time can be used by specifying the correct flag. The log file is read from standard input unless the -f flag is specified.

[![Travis CI tests](https://travis-ci.org/ianheggie/rawk_log.png)](https://travis-ci.org/ianheggie/rawk_log)

## Installation

Add this line to your application's Gemfile:

    gem 'rawk_log'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rawk_log

### Patching logger

To enable reporting by controller#action add the following to at the end of the environment.rb file:

    require 'rawk_log/patch_logger'

This will patch Logger and/or ActiveSupport::BufferedLogger to append " (pid:#{$$})" to each line of the log file.

This patch is required where the url is not listed on the completed line (eg rails 3.2).

## Usage

rawk_log usage:

  -?  Display this help.

  -d  Use DB times as data points. These times are found after 'DB:' in the log file. This overrides the default behavior of using the total request time.

  -f <filename> Use the specified file instead of standard input.

  -h  Display this help.

  -r  Use Render times as data points. These times are found after 'Rendering:' in the log file. This overrides the default behavior of using the total request time.

  -s <count> Display <count> results in each group of data.

  -t  Test

  -u  Group requests by url instead of the controller and action used. This is the default behavior if there is are no process ids in the log file.

  -w <count> Display the top <count> worst requests.

	-x <date> Date (inclusive) to start parsing in 'yyyy-mm-dd' format.

	-y <date> Date (inclusive) to stop parsing in 'yyyy-mm-dd' format.

Example usage:
    rawk_log log/production.log

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This software is Beerware, if you like it, buy yourself a beer
or something nicer ;)

## Thanks go to

* Created by Chris Hobbs of Spongecell, LLC - http://ckhsponge.wordpress.com/2006/10/11/ruby-on-rails-log-analyzer-rawk/
* Various contributers on github
* Railscast for bringing it to my attention: http://railscasts.com/episodes/97-analyzing-the-production-log
