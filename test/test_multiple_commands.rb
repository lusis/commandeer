require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestMultipleCommands < MiniTest::Unit::TestCase
  def setup
    require 'helpers/multiple_commands.rb'
    @commands = Commandeer.commands
  end

  def test_has_all_commands
    ["command_one", "command_two"].each do |c|
      assert_includes(@commands.keys, c)
    end
  end

  # To ensure top-level commands are new-lined
  def test_format_output
    out, err = capture_io do
      begin
        Commandeer.parse!('')
      rescue SystemExit
      end
    end

    assert_match(out, /^.*Usage:.*\n\n\tcommand_one*\n\tcommand_two\n.*$/)
  end
end
