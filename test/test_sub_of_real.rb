require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestSubOfRealCommand < MiniTest::Unit::TestCase
  def setup
    require 'helpers/sub_of_real_command.rb'
    @commands = Commandeer.commands
    puts @commands
  end

  def test_has_command
    assert_includes(@commands.keys, "parent")
  end

  def test_command_has_parser
    assert(@commands['parent'][:parser], "parse")
  end

  def test_command_has_class
    assert(@commands['parent'][:klass], "Parent")
  end

  def test_has_subcommands
    assert_includes(@commands['parent'].keys, 'subcommands')
  end

  def test_has_subcommand
    assert_includes(@commands['parent']['subcommands'].keys, 'child')
  end

  def test_subcommand_has_parser
    assert(@commands['parent']['subcommands']['child'][:parser], "parse")
  end

  def test_subcommand_has_klass
    assert(@commands['parent']['subcommands']['child'][:klass], "Child")
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
