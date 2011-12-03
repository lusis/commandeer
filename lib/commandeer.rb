module Commandeer
  VERSION = "0.0.1"

  @commands = {}

  def self.commands
    @commands
  end

  def self.reset!
    @commands = {}
  end

  def self.add_command(opts)
    command = opts[:command].to_s
    parent = opts[:parent].to_s
    klass = opts[:klass].to_s
    parser = opts[:parser].to_s
    h = {}
    case parent
    when "top"
      h = {:parser => parser, :klass => klass}
      @commands[command] ||= {}
      @commands[command].merge!(h)
    else
      h[command] = {:parser => parser, :klass => klass}
      @commands[parent] ||= {}
      @commands[parent]["subcommands"] ||= {}
      @commands[parent]["subcommands"].merge!(h)
    end
  end

  def self.parse!(args, script_name=__FILE__)
    @script_name = script_name
    # We haz no commands registered
    if @commands.size == 0
      puts "No known commands!"
      exit(1)
    end

    # No args. Let's show what we have registered
    if (args.size == 0) || (args[0] =~ /^-/)
      output = ''
      output << "Usage: #{@script_name} [command options] or [command subcommand options]\n\n"
      @commands.each do |command, options|
        next if (command==:klass || command==:parser)
        output << "\t#{command}\t"
        unless options["subcommands"].nil?
          output << "Subcommands:"
          options["subcommands"].each do |sub, opts|
            output << " #{sub}"
          end
        end
      end
      puts output
      exit
    end

    # Workflow
    # Check if current scope is a valid command
    scope = args.shift

    # set the current command or return help
    @commands.has_key?(scope) ? command=@commands[scope] : (puts "Unknown command: #{scope}\n"; self.parse!("-h"))

    subcommands = command["subcommands"]

    if subcommands
      output = ''
      output << "`#{scope}` has the following registered subcommands:\n"
      subcommands.keys.each {|x| output << "\t#{x}" }
      puts output
    end if args.size == 0

    if command.has_key?(:parser)
      output = ''
      output << "\n`#{scope}` also takes options"
      output << "\ntry running '#{@script_name} #{scope} --help'"
      puts output
    end if args.size == 0

    if args.size > 0 
      # This currently blows up on 'command --help'
      if subcommands.has_key?(args[0])
        # Okay so the next arg is a registered subcommand. Let's shift args
        new_scope = args.shift
        warning =<<-EOF
        Warning! `#{new_scope}` is a registered subcommand for `#{scope}` but `#{scope}` also takes options.
        This can cause unexpected results if `#{scope}` has an option named `#{new_scope}`
        EOF
        puts warning

        parser = subcommands[new_scope][:parser]
        klass = subcommands[new_scope][:klass]
      else
        parser = command[:parser]
        klass = command[:klass]
      end
    else
      parser = command[:parser]
      klass = command[:klass]
    end
    begin
      handler = constantize(klass)
      handler.send parser.to_sym, args
    rescue NoMethodError
      if command[:parser]
        puts "#{handler}##{parser} method does not exist"
      end
    rescue Exception => e
      puts e.message
    end
  end

  # Ripped from the ActiveSupport headlines!
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def command(command, opts={})
      opts[:command] = command
      opts[:parent] ||= :top
      opts[:klass] ||= self.to_s
      opts[:parser] ||= :parse
      Commandeer.add_command(opts)
    end
  end
end
