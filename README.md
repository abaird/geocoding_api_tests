# GeocodingApi

This repository tests Google's [Geocoder API](https://developers.google.com/maps/documentation/geocoding/intro). This
is meant to be a demonstration of how I would go about building an API framework and, although they could be used
to write a larger test suite, I don't have the time to make it truly exhaustive.

## Installation

These tests were developed and should be run under Ruby 2.2.4 and were bundled with Bundler 1.11.2. Clone/extract this
repository into a directory that has access to the correct versions of Ruby and Bundler and execute:

`bundle install`

## Usage

To run the tests, execute the following:

`API_KEY=<your key here> bundle exec rspec`

Where the API_KEY is your key generated by Google. You can generate one [here](https://developers.google.com/maps/documentation/geocoding/get-api-key#get-an-api-key).
No, you can't have mine.

## Test Strategy

These tests were mainly taken off of the [Geocoder API](https://developers.google.com/maps/documentation/geocoding/intro)
document and any other sources that could be found on the Internet. The tests were chosen to achieve a wide amount of
coverage of the features discussed in the public documentation. Obviously there would be a lot more tests if I was using
this to really test a production environment.

## Discussion

### Pending Examples
There are a few pending examples still in the code which I have marked to skip. These examples mainly represent scenarios
that I feel like aren't consistent with what's in Google's doc. In fact, quite a few of the examples in the doc don't work
either in my test suite or when I just manually query Google's service. For example, the first example in filtering_spec.rb is supposed
to be able to filter out all of the other cities named `Paris` other than those that are in the Texas bounding box. This
seems like it ought to work but still returns 6 cities with the name `Paris`. If I were in this situation I would reach
out to a product person at Google to get some clarification on what should and shouldn't work.

### Hard Coded Data
I have tried to avoid having hard coded data in the tests. However, since this is a test in a production environment, I
really don't have any choice but have specific data points to test with. I mainly went with my own home address and some
other well known landmarks. In almost all of these cases I put all of the test data in `let` statements at the top of the
tests. That way it should be easy to replace the test data if needed.

### An alternate test approach
One test approach could be keeping a set of queries and a master copy of what the response should be. That way when
you play them back you would just compare the response to the master copy. The problem with this is that:  
1. you would have to write a pretty sophisticated comparator that would help you define what line was different  
2. there could be somethings that might be different that wouldn't matter (lat/lng precision)  
3. keeping up with the different files would be it's own maintenance overhead esp. since GIS data isn't always static  
Ultimately I decided that this approach woudln't fit my time budget for this project.

### Other tests I would do if...
There are some other tests that I think are important but I didn't have the time or access to do it.  
1. Performance tests: I didn't want to risk getting blocked while I was developing this test, but I think this is obviously
pretty important for a public query API. I would prioritize testing any kind of throttling mechanism and then make sure
that people that paid extra for it could get around these limits.  
2. XML: I wrote one XML test (see `basic_query_spec.rb`) that parsed an XML return type. Ideally I would be able to turn
a switch and seamlessly use XML instead of JSON. However, I discovered that Google uses different keys for XML than JSON and
so it wasn't nearly as simple as I thought. If I had more time I could make a parallel model for XML that I could parse
just as easily.  
