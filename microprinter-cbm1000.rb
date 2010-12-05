# Supplemental library for the microprinter library, including commands
# for the CBM-1000 printer
#
# See https://github.com/rooreynolds/microprinter for more

require 'rubygems'
require 'Microprinter'

class Microprinter 

  # CBM-1000-specific commands

  LINE_FEED = 0x0A
  FEED_N    = 0x64    # Usage: 
                      # COMMAND FEED_N 1   # => feeds 1 lines
                      # COMMAND FEED-N 255 # => feeds 255 lines
  
  def feed(lines=3)
    @sp.putc COMMAND
    @sp.putc FEED_N
    @sp.putc lines
    @sp.flush
  end

  def feed_and_cut # utility method. 
    self.feed 6
    self.cut
  end

end
