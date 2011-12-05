require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestOverrideAll < MiniTest::Unit::TestCase
  def setup
    require 'helpers/all_override'
    @commands = Commandeer.commands
  end

  def test_has_command
    assert_includes(@commands.keys, "override")
  end

  def test_has_subcommands
    assert_includes(@commands['override'].keys, 'subcommands')
  end

  def test_has_subcommand
    assert_includes(@commands['override']['subcommands'].keys, 'random')
  end

  def test_subcommand_has_parser
    assert(@commands['override']['subcommands']['random'][:parser], "zing")
  end

  def test_subcommand_has_klass
    assert(@commands['override']['subcommands']['random'][:klass], "Foo")
  end

  def test_output_noopts
    out, err = capture_io do
      begin
        Commandeer.parse! ''
      rescue SystemExit
      end
    end
    assert_match(out, /^.*Usage.*\n\n\t.*override\tSubcommands:\t random.*$/)
  end

  def test_output_override
    out, err = capture_io do
      begin
        Commandeer.parse! %w{override}
      rescue SystemExit
      end
    end
    assert_match(out, /`override` has the following registered subcommands:\n\trandom.*$/)
  end

  def test_output_random_options
    out, err = capture_io do
      begin
        Commandeer.parse! %w{override random foo bar baz}
      rescue SystemExit
      end
    end
    assert_match(out, /^foo\nbar\nbaz\n*$/)
  end
end
