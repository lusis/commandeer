class TestMethods < MiniTest::Unit::TestCase
  def setup
    require 'helpers/command.rb'
    @commands = Commandeer.commands
  end

  def test_has_command
    assert_includes(@commands.keys, "foo")
  end

  def test_has_parser
    assert(@commands['foo'][:parser], "parse")
  end

  def test_has_klass
    assert(@commands['foo'][:klass], "PrimaryCommand")
  end

  def test_output_noopts
    out, err = capture_io do
      begin
        Commandeer.parse! ''
      rescue SystemExit
      end
    end

    assert_match(out, /^.*\tfoo.*$/)
  end

  def test_output_foo
    out, err = capture_io do
      begin
        Commandeer.parse! %w{foo}
      rescue SystemExit
      end
    end

    assert_match(out, /^`foo` also takes options.*$/)
  end
end
