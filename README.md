# GeocodingApi

This repository tests Google's [Geocoder API](https://developers.google.com/maps/documentation/geocoding/intro). The
tests are meant to be a demonstration of how I would go about building an API framework and, although they could be used
to write a larger test suite, I don't have the time to make it truly exhaustive.

## Installation

These tests run under Ruby 2.2.4 and were bundled with Bundler 1.11.2. Clone/extract this repository into a directory
that has access to the correct versions of Ruby and Bundler and execute:

`bundle install`

## Usage

To run the tests, execute the following:

`API_KEY=ABCDEFGHIG bundle exec rspec`

