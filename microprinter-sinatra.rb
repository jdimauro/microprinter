require 'rubygems'
require 'sinatra'
# require 'sinatra/config_file'
require 'rss'
require 'open-uri'
require 'cgi'
require './Microprinter_debug.rb' # uncomment this to print to the console instead of the printer. 
# require './Microprinter.rb' 

configure do
  set :arduinoport, "/dev/cu.usbmodem24131" # or whatever yours is. 
  # config_file "settings.yml"
end


before do
  @printer = Microprinter_debug.new(settings.arduinoport)
  # @printer = Microprinter.new(settings.arduinoport)
  @printer.set_character_width_normal
end

def cleanHTML(text)
  # nb could use htmlentities library to unencode HTML entities, but how to deal with non-ascii characters? Need to turn unicode chars to plain text somehow 
  newtext = text
  newtext.gsub! "&\#8211;", "-" #replace em-dash
  newtext.gsub! "&\#8216;", "'" # replace curly quotes
  newtext.gsub! "&\#8217;", "'"
  newtext.gsub! "&\#8230;", "..."
  return newtext
end 

get '/print/cut' do
  @printer.cut
  "cut"
end 

get '/print/weather' do
  # print content from http://www.bbc.co.uk/weather/ukweather/south/cloud.shtml?summary=show02
  @weatherurl = "http://boilerpipe-web.appspot.com/extract?extractor=LargestContentExtractor&output=text&url=http%3A%2F%2Fwww.bbc.co.uk%2Fweather%2Fukweather%2Fsouth%2Fcloud.shtml%3Fsummary%3Dshow02"
  weather_content = ""
  open(@weatherurl) do |f|
    weather_content = f.read
  end
  @printer.print_and_cut weather_content.split("\n")
  "Weather printed"
end

get '/print' do
  pass unless params[:text] # use this rule if 'text' param exists
  @text = params[:text]
  @printer.print_and_cut [@text, "", request.url]
  "Text: #{@text}"
end

get '/print' do
  pass unless params[:url] # use this rule if 'url' param exists
  @url = params[:url]
  #TODO: do some processing...

  #TODO: maybe use a regex to identify URLs, rather than explicity ask for a ?url= param? 
  # Something like this, from http://daringfireball.net/2010/07/improved_regex_for_matching_urls
  # (?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))

  # From sinatra readme (http://www.sinatrarb.com/intro.html)
  # Route matching with Regular Expressions:

  #   get %r{/hello/([\w]+)} do
  #     "Hello, #{params[:captures].first}!"
  #   end

  # Or with a block parameter:
  # 
  #   get %r{/hello/([\w]+)} do |c|
  #     "Hello, #{c}!"
  #   end

  "Url: #{@url}"
end

get '/print' do
  pass unless params[:feed] # use this rule if 'rss' param exists
  @feed = params[:feed]
  rss_content = ""
  open(@feed) do |f|
    rss_content = f.read
  end
  rss = RSS::Parser.parse(rss_content, false)
  # rss.items.size
  # rss.channel.description

  @printer.print_text ["#{rss.channel.title} (#{rss.channel.link})"]
  @printer.set_font_weight_bold
  puts rss.items[0].title
  puts cleanHTML(rss.items[0].title)
  @printer.print_text [cleanHTML(rss.items[0].title)]
  @printer.set_font_weight_normal
  @printer.set_character_width_narrow
  @printer.print_text [cleanHTML(rss.items[0].description)]
  @printer.set_underline_on
  @printer.print_text [rss.items[0].link]
  @printer.set_underline_off
  @printer.print_text [rss.items[0].date.strftime("%B %d, %Y")]
  @printer.set_character_width_normal
  @printer.feed_and_cut
  "Feed: #{@feed}"
end

get '/print' do
   "Try /print?text=foo | /print?url=foo | /print?feed=foo"
end

get '/' do
  "try /print"
  
  # TODO: display a friendly big text field here where you can paste in a URL to be printed
  # TODO: make the sinatra app into a configuration tool where you can manage feeds to be automatically polled and printed, as well as how often they get polled, printed, etc. 
end

get '/linkformat' do
  linktext = <<-END_OF_LINKTEXT
    Implementing the Demon-Haunted Notebook
    http://paperbits.net/post/1471783673/implementing-the-demon-haunted-notebook
    
    
    http://goo.gl/qjZ8T
  END_OF_LINKTEXT
  
  @printer.feed
  @printer.print_and_cut linktext.split("\n")
end
