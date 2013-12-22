require 'test/unit'

class Rails40Test < Test::Unit::TestCase

  def setup
    @output = `ruby bin/rawk_log -f test/examples/rails40.log`
    @exit_status = $?.to_i
  end

  def test_no_methods_reported
    assert_no_match(/PostsController/, @output)
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_finds_entries
    assert_match(/^\/posts/, @output)
    assert_match(/^\/posts\s+5\s/, @output)
  end

  def test_sums_entries
    assert_match(/^\/posts+\s+5\s+0\.09/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
