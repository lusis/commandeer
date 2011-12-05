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
    assert_output("Usage: test_multiple_commands [command options] or [command subcommand options]\n\n\tcommand_two\t\n\tcommand_one\t\n") do
      begin
        Commandeer.parse!('', 'test_multiple_commands')
      rescue SystemExit
      end
    end
  end
end
