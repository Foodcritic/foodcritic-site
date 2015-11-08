# foodcritic-site
[![Built on Travis](https://travis-ci.org/acrmp/foodcritic-site.svg?branch=master)](https://travis-ci.org/acrmp/foodcritic-site)

This is the website for foodcritic, a lint tool for Chef cookbooks.

It uses [Middleman](https://middlemanapp.com/). You can visit the published website at: [http://foodcritic.io](http://foodcritic.io)

# Building

    $ bundle install
    $ bundle exec rake

# Deployment

    $ export AWS_ACCESS_KEY_ID=<secret>
    $ export AWS_SECRET_ACCESS_KEY=<secret>
    $ bundle exec rake deploy

# License
MIT - see the accompanying [LICENSE](https://github.com/acrmp/foodcritic-site/blob/master/LICENSE) file for details.

# Contributing
Please fork and submit a pull request on an individual branch per change.
