require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestMethods < MiniTest::Unit::TestCase
  def setup
    @commands = Commandeer.commands
  end

  def test_commands_is_hash
    assert_kind_of(Hash, @commands)
  end

  def test_respond_to_reset
    assert_respond_to(Commandeer, :reset!)
  end

  def test_respond_to_add_command
    assert_respond_to(Commandeer, :add_command)
  end

  def test_respond_to_parse
    assert_respond_to(Commandeer, :parse!)
  end

  def test_respond_to_constantize
    assert_respond_to(Commandeer, :constantize)
  end

end
