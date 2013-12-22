require 'test/unit'

class EmptyTest < Test::Unit::TestCase

  def setup
    bin = File.join(File.dirname(__FILE__), '..', 'bin')
    examples = File.join(File.dirname(__FILE__), 'examples')
    @output = `ruby #{bin}/rawk_log -f #{examples}/empty.log`
    @exit_status = $?.to_i
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum\(secs\) +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_lists_zero_entries
    assert_match(/^All Requests +0$/, @output)
  end

  def test_no_top_lists
    assert_no_match(/^Top /, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
