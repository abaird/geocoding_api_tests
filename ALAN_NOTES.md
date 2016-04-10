

One test approach could be keeping a set of queries and a master copy of what the response should be. That way when
you play them back you would just compare the response to the master copy. The problem with this is that 1) you would
have to write a pretty sophisticated comparator that would help you define what line was different 2) there could be
somethings that might be different that wouldn't matter (lat/lng precision) and 3) keeping up with the different files
would be it's own maintenance overhead.

I'm only testing with my one location. I could use some more (and probably will), but if I had more interesting data points
then the tests might be different. In a real test, I would probably be testing against a limited data set or have control
over what kinds of objects are loaded.