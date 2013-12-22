require 'test/unit'

class Rails23Test < Test::Unit::TestCase

  def setup
    bin = File.join(File.dirname(__FILE__), '..', 'bin')
    examples = File.join(File.dirname(__FILE__), 'examples')
    @output = `ruby #{bin}/rawk_log -f #{examples}/rails23.log`
    @exit_status = $?.to_i
  end

  def test_no_methods_reported
    assert_no_match(/ItemsController/, @output)
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum\(s\) +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_finds_entries
    assert_match(/^\/items/, @output)
    assert_match(/^\/items\s+5\s/, @output)
  end

  def test_sums_entries
    assert_match(/^\/items\s+5\s+0\.06/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
