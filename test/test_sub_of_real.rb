require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestSubOfRealCommand < MiniTest::Unit::TestCase
  def setup
    require 'helpers/sub_of_real_command.rb'
    @commands = Commandeer.commands
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
    assert_match(out, /^.*Usage.*\n\n\t.*parent\tSubcommands: child.*$/)
  end

  def test_output_parent
    out, err = capture_io do
      begin
        Commandeer.parse! %w{parent}
      rescue SystemExit
      end
    end
    assert_match(out, /`parent` has the following registered subcommands:\n\tchild.*$/)
  end

  def test_output_parent_options
    out, err = capture_io do
      begin
        Commandeer.parse! %w{parent --help}
      rescue SystemExit
      end
    end
    assert_match(out, /^parent \[options\]*$/)
  end

  def test_output_child_with_warning
    out, err = capture_io do
      begin
        Commandeer.parse! %w{parent child}
      rescue SystemExit
      end
    end
    assert_match(out, /^.*Warning! `child` is a registered subcommand for `parent` but `parent` also takes options.*$/)
  end

  def test_output_child_options
    out, err = capture_io do
      begin
        Commandeer.parse! %w{parent child --help}
      rescue SystemExit
      end
    end
    assert_match(out, /^.*\nchild \[options\]*$/)
  end
end
