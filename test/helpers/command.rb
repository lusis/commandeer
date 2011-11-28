require 'optparse'

class PrimaryCommand
  include Commandeer

  command "foo"

  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.banner = "foo [options]"

      opts.on("-f", "--foo FOOTHING", "The option for foo") do |f|
        options[:f] = f
      end
      opts.on_tail("-h", "--help", "foo help") do
        puts opts
        exit(1)
      end
    end
    begin
      opts.parse!(args)
    rescue OptionParser::InvalidOption => e
      puts e
      puts opts
    end
  end
end
