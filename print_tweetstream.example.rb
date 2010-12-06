#!/usr/bin/env ruby
require "rubygems"
require "microprinter-cbm1000"
require "tweetstream"

p=Microprinter.new("/dev/cu.usbmodemfa241")
p.set_character_width_normal

USERNAME = "your username"  # Replace with your Twitter user
PASSWORD = "your password"    # and your Twitter password

TweetStream::Client.new(USERNAME, PASSWORD).track('imwikileaks') do |status|
  p.feed 2
  p.set_character_width_narrow
  p.print_text "#{status.created_at} - #{status.user.location}\n"
  p.set_character_size_quadruple
  p.print "\@#{status.user.screen_name}:"
  p.feed 2
  p.set_print_mode_normal
  p.print_text "#{status.text}"
  p.feed 6
  p.cut
  # p.print_text "#{status.created_at}\n\@#{status.user.screen_name} - #{status.user.name} - #{status.user.location}\n #{status.text}\n"
end