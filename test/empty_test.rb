require 'test/unit'

class EmptyTest < Test::Unit::TestCase

  def setup
    @output = `ruby bin/rawk_log -f test/examples/empty.log`
    @exit_status = $?.to_i
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_lists_zero_entries
    assert_match(/^All Requests +0$/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
