require 'test/unit'

class MixedTest < Test::Unit::TestCase

  def setup
    bin = File.join(File.dirname(__FILE__), '..', 'bin')
    examples = File.join(File.dirname(__FILE__), 'examples')
    @output = `ruby #{bin}/rawk_log -f #{examples}/mixed.log`
    @exit_status = $?.to_i
  end

  def test_methods_reported
    assert_match(/ItemsController/, @output)
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum\(secs\) +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_has_top_lists
    assert_match(/^Top /, @output)
  end

  def test_finds_entries
    assert_match(/^ItemsController#index/, @output)
    assert_match(/^ItemsController#index\s+5\s/, @output)
    assert_match(/^PostsController#create/, @output)
    assert_match(/^PostsController#create\s+5\s/, @output)
  end

  def test_sums_entries
    assert_match(/^Items\S+\s+5\s+0\.06/, @output)
    assert_match(/^Posts\S+\s+5\s+0\.09/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
