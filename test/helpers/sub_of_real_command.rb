require 'optparse'

class Parent
  include Commandeer

  command "parent"

  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.banner = "parent [options]"

      opts.on("-p", "--parent PARENTTHING", "The option for parent") do |f|
        options[:f] = f
      end
      opts.on_tail("-h", "--help", "parent help") do
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

class Child
  include Commandeer

  command "child", :parent => 'parent'

  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.banner = "child [options]"

      opts.on("-c", "--child CHILDTHING", "The option for child") do |f|
        options[:f] = f
      end
      opts.on_tail("-h", "--help", "child help") do
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
