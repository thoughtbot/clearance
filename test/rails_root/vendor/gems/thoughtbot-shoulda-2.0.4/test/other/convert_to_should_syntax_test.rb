require 'test/unit'

class ConvertToShouldSyntaxTest < Test::Unit::TestCase # :nodoc:

  BEFORE_FIXTURE = <<-EOS
    class DummyTest < Test::Unit::TestCase

      should "Not change this_word_with_underscores" do
      end

      def test_should_be_working
        assert true
      end

      def test_some_cool_stuff
        assert true
      end

      def non_test_method
      end

    end
  EOS

  AFTER_FIXTURE = <<-EOS
    class DummyTest < Test::Unit::TestCase

      should "Not change this_word_with_underscores" do
      end

      should "be working" do
        assert true
      end

      should "RENAME ME: test some cool stuff" do
        assert true
      end

      def non_test_method
      end

    end
  EOS
  
  FIXTURE_PATH = "./convert_to_should_syntax_fixture.dat"

  RUBY = ENV['RUBY'] || 'ruby'

  def test_convert_to_should_syntax
    File.open(FIXTURE_PATH, "w") {|f| f.write(BEFORE_FIXTURE)}
    cmd = "#{RUBY} #{File.join(File.dirname(__FILE__), '../../bin/convert_to_should_syntax')} #{FIXTURE_PATH}"
    output = `#{cmd}`
    File.unlink($1) if output.match(/has been stored in '([^']+)/)
    assert_match(/has been converted/, output)
    result = IO.read(FIXTURE_PATH)
    assert_equal result, AFTER_FIXTURE
  end

  def teardown
    File.unlink(FIXTURE_PATH)
  end

end
