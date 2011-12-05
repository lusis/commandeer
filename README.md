# Commandeer
Commandeer is a simple (and rather ghetto) implementation of a class-based CLI builder.

## Needs/Goals
- Easily create git-style subcommands
- Be option parser agnostic
- Not be a framework

The idea is simply that you can expose any class as a git-style CLI option. Your bin script can then simply call `Commandeer.parse!(ARGV)`.

This came about when trying to create a simple all-in-one CLI application. I wanted to be able to do:

- `myapp log search [options here]`
- `myapp log tail [options here]`
- `myapp deploy appname`
- `myapp someother command [options here]`

However I didn't want to maintain a single option parser. The cli app was modular and I just wanted to keep the options for a command in the class that handled it.
In this way, I didn't have to remember to go update the option parser defintion/bin script when I added new functionality.

### Simple example

```ruby
# test-app.rb
require 'commandeer'

class Foo
  include Commandeer
  command "run"

  def self.parse(opts)
    puts opts
  end
end

Commandeer.parse!(ARGV, __FILE__)
```

Without any options:

```
Usage: ./test-app.rb [command options] or [command subcommand options]

	run
```

Once you add a known subcommand to the arguments, everything is passed off to the class' parse method. In the above example, it simply prints the passed args to output.
What this means is that you can use ANY option parser (or none at all) that you like. You could conceivably use `slop`, `optparse` and custom stuff all in the same codebase.
Commandeer is like honey badger. It just doesn't give a damn.

The only "requirement" is that the parser for the class be a class method.

By default, Commandeer will look for a class method called `parse` but most everything is overrideable:

- method name: _You can call a method other than parse_
- class: _You can call another class' parse method_
- parent: _You can set the command to be a subcommand by giving it a parent. The parent can, but doesn't have to be, a real command._

### Complex example

```ruby
# override-all-the-things
class Override
  def self.zing(args)
    puts "I am overriding all the things:"
    puts args
  end
end

class AllTheThings
  include Commandeer

  command "all-the-things", :parent => 'override', :klass => "Override", :parser => "zing"
end

Commandeer.parse!(ARGV)
```

Output:

```
$ test-app.rb
Usage: ./test-app.rb [command options] or [command subcommand options]

	override	Subcommands: all-the-things

$ test-app.rb override
`override` has the following registered subcommands:
	all-the-things

$ ./test-app.rb override all-the-things for-great-justice
I am overriding all the things:
for-great-justice
```

### Mixing command options and subcommands
You can even add a subcommand to a top-level command that has its own parser (but you'll get a nasty warning about it).

```ruby
require 'commandeer'
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

Commandeer.parse!(ARGV,__FILE__)
```

Output:

```
$ ./test-app.rb 
Usage: ./test-app.rb [command options] or [command subcommand options]

	parent	Subcommands: child

$ ./test-app.rb parent
`parent` has the following registered subcommands:
	child

$ ./test-app.rb parent --help
parent [options]
    -p, --parent PARENTTHING         The option for parent
    -h, --help                       parent help
exit

$ ./test-app.rb parent child
        Warning! `child` is a registered subcommand for `parent` but `parent` also takes options.
        This can cause unexpected results if `parent` has an option named `child`

$ ./test-app.rb parent child --help
        Warning! `child` is a registered subcommand for `parent` but `parent` also takes options.
        This can cause unexpected results if `parent` has an option named `child`
child [options]
    -c, --child CHILDTHING           The option for child
    -h, --help                       child help
```

# Contributing

* Fork
* New branch
* Pull Request
* Collect eternal gratitude


# Fun fact of the day
I really wanted to call this "cylon" so you could do this:

```ruby
class Foo
  include Cylon

  by_your_command "kill_humans"
end
```

Oh well.
