require 'test/unit'

class SelfTest < Test::Unit::TestCase

  def setup
    bin = File.join(File.dirname(__FILE__), '..', 'bin')
    examples = File.join(File.dirname(__FILE__), 'examples')
    @output = `ruby #{bin}/rawk_log -t`
    @exit_status = $?.to_i
  end

  def test_no_failures_reported
    assert_no_match(/Failure/, @output)
  end

  def test_success_reported
    assert_match(/Success/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
