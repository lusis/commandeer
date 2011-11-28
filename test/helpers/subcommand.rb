require 'optparse'

class SubCommand
  include Commandeer

  command "bar", :parent => 'fakeparent'

  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.banner = "bar [options]"

      opts.on("-b", "--bar BARTHING", "The option for bar") do |f|
        options[:f] = f
      end
      opts.on_tail("-h", "--help", "bar help") do
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
