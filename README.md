Microprinter Arduino library, Java and Ruby API
===============================================

<http://rooreynolds.com/category/microprinter/>  
<http://microprinter.pbworks.com/>  

Contents
--------

 - microprinter_sketch.pde - an arduino sketch  
 - Microprinter.java - a java class to communicate with the arduino  
 - Microprinter.rb - a ruby class to communicate with the arduino  
 - Microprinter_debug.rb - ruby class which prints to console rather than printer  
 - microbroker-sinatra - sinatra app   
   usage: `ruby -rubygems microprinter-sinatra.rb`  
  `http://localhost:4567/print/weather`  
  `http://localhost:4567/print?text=test text`  
  `http://localhost:4567/print?feed=http://rooreynolds.com/feed/`  


Setting Up the Sinatra App
--------------------------

For the sinatra app, you will need:

The [Sinatra](http://www.sinatrarb.com/) gem. `#=> gem install sinatra`
The [Sinatra Config File](https://github.com/rkh/sinatra-config-file) gem. `#=> gem install sinatra-config-file`

There's very little in the way of documentation, and the code is currently a hash of notes to self, ideas, and doodles.  

Working on that.  

Really. 


Elsewhere: 
---------
  Ben O'Steen has a [Python port of the library][pymicro]. 
  
[pymicro]: https://github.com/benosteen/microprinter/
  
TODO
----

In no particular order, some things to be done:

-   add code to manage `/print?url=http://url.com`  
-   check RSS feeds and print new items as they appear  
    Examples: twitter, latest links on pinboard.in, latest instapaper items…
-   make URL for weather reports configurable so it's not hard coded to south of england (!)
-   create a config file for arduino port, RSS feeds, weather location
-   re-integrate debug library into microprinter.rb - pipe serial messages to console for debugging and automated testing. 
-   format the RSS feed item printout to shorten the URL and print properly so that it can be OCR'd with Google Goggles
-   possibly port Ben O'Steen's image stuff so that you can print QRCodes on links, as well as images. 
-   barcodes, 1D (built-in capability)
-   make `/` do something useful, like display a form that you can feed printable items into.

### Also, I want a pony

Some todo items that may or may not end up being useful, feasible, interesting, or just plain dumb.

-   add some kind of polling behavior for specified feeds
-   integrate tom taylor's microprinter-over-ethernet-shield setup, so you can use this sinatra app with one or the other? 
-   bookmarklet for printing locally
