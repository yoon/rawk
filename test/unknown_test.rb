require 'test/unit'

class UnknownTest < Test::Unit::TestCase

  def setup
    bin = File.join(File.dirname(__FILE__), '..', 'bin')
    examples = File.join(File.dirname(__FILE__), 'examples')
    @output = `ruby #{bin}/rawk_log -f #{examples}/unknown.log`
    @exit_status = $?.to_i
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_lists_zero_entries
    assert_match(/^All Requests +0/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
