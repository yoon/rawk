require 'test/unit'

class Rails32Test < Test::Unit::TestCase

  def setup
    bin = File.join(File.dirname(__FILE__), '..', 'bin')
    examples = File.join(File.dirname(__FILE__), 'examples')
    @output = `ruby #{bin}/rawk_log -f #{examples}/rails32.log`
    @exit_status = $?.to_i
  end

  def test_methods_reported
    assert_match(/Rails::InfoController#properties/, @output)
  end

  def test_results_without_pid_not_matched_to_url
    assert_no_match(/^\/ /, @output)
  end

  def test_results_without_pid_not_matched_to_method
    assert_no_match(/ArticlesController#index/, @output)
  end

  def test_results_without_pid_reported_as_unknown
    assert_match(/^Unknown/, @output)
    assert_match(/^Unknown\s+1\s/, @output)
    assert_match(/^Unknown\s+1\s+0.02/, @output)
  end

  def test_has_top_lists
    assert_match(/^Top /, @output)
  end

  def test_outputs_header
    assert_match(/^Request +Count +Sum\(secs\) +Max +Median +Avg +Min +Std$/, @output)
  end

  def test_finds_entries
    assert_match(/^Rails::InfoController#properties/, @output)
    assert_match(/^Rails::InfoController#properties\s+10\s/, @output)
  end

  def test_sums_entries
    assert_match(/^Rails::InfoController#properties\s+10\s+0.02/, @output)
  end

  def test_exit_status
    assert_equal(0, @exit_status)
  end

end
