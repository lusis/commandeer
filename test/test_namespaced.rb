require "#{File.expand_path(File.join(File.dirname(__FILE__), "helper.rb"))}"

class TestNameSpaced < MiniTest::Unit::TestCase
  def setup
    require 'helpers/namespaced.rb'
    @commands = Commandeer.commands
  end

  def test_has_command
    assert_includes(@commands.keys, "namespaced")
  end

  def test_namespaced_has_parser
    assert(@commands['namespaced'][:parser], "parse")
  end

  def test_has_klass
    assert(@commands['namespaced'][:klass], "Name::Spaced")
  end

  def test_output_noopts
    out, err = capture_io do
      begin
        Commandeer.parse! ''
      rescue SystemExit
      end
    end
    assert_match(out, /^.*Usage.*\n\n\t.*namespaced.*$/)
  end

  def test_output_namespaced
    out, err = capture_io do
      begin
        Commandeer.parse! %w{namespaced an_opt}
      rescue SystemExit
      end
    end
    assert_match(out, /an_opt/)
  end

end
