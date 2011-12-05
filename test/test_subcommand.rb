require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestSubCommand < MiniTest::Unit::TestCase
  def setup
    require 'helpers/subcommand.rb'
    @commands = Commandeer.commands
  end

  def test_has_command
    assert_includes(@commands.keys, "fakeparent")
  end

  def test_has_subcommands
    assert_includes(@commands['fakeparent'].keys, 'subcommands')
  end

  def test_has_subcommand
    assert_includes(@commands['fakeparent']['subcommands'].keys, 'bar')
  end

  def test_subcommand_has_parser
    assert(@commands['fakeparent']['subcommands']['bar'][:parser], "parse")
  end

  def test_has_klass
    assert(@commands['fakeparent']['subcommands']['bar'][:klass], "SubCommand")
  end

  def test_output_noopts
    out, err = capture_io do
      begin
        Commandeer.parse! ''
      rescue SystemExit
      end
    end
    assert_match(out, /^.*Usage.*\n\n\t.*fakeparent\tSubcommands: bar.*$/)
  end

  def test_output_fakeparent
    out, err = capture_io do
      begin
        Commandeer.parse! %w{fakeparent}
      rescue SystemExit
      end
    end
    assert_match(out, /`fakeparent` has the following registered subcommands:\n\tbar.*$/)
  end

  def test_output_bar_options
    out, err = capture_io do
      begin
        Commandeer.parse! %w{fakeparent bar --help}
      rescue SystemExit
      end
    end
    assert_match(out, /^bar \[options\]*$/)
  end
end
