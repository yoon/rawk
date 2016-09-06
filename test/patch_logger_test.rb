require 'test/unit'

class Logger

  def initialize(level)
    # don't care
  end

end


module ActiveSupport

  class BufferedLogger

    def initialize(level)
      # don't care
    end

    # fake to get result of block back
    def add(severity, message = nil, progname = nil, &block)
      (block && block.call) || message
    end

  end
end

#require "rawk_log/patch_logger"

require File.dirname(__FILE__) + '/../lib/rawk_log/patch_logger'

class BufferedLoggerTest < Test::Unit::TestCase

  def setup
    @logger = ActiveSupport::BufferedLogger.new(nil)
  end

  def test_loaded_constant_is_true
    assert_equal(true, RawkLog::PATCHED_BUFFERED_LOGGER)
  end

  def test_leaves_blank_lines_alone
    msg = @logger.add(nil, "\n\n")
    assert_equal("\n\n", msg)
  end

  def test_adds_only_newline_to_empty_string
    msg = @logger.add(nil, "")
    assert_equal("\n", msg)
    msg = @logger.add(nil, msg)
    assert_equal("\n", msg)
  end

  def test_adds_pid_to_line
    msg = @logger.add(nil, "some message")
    assert_match(/^some message \(pid:\d+\)\n$/m, msg)
  end

  def test_adds_pid_to_line_only_once
    msg = @logger.add(nil, "some message")
    msg = @logger.add(nil, msg)
    assert_match(/^some message \(pid:\d+\)\n$/m, msg)
  end

  def test_adds_pid_to_all_lines
    msg = @logger.add(nil, "some message\nanother message")
    msg = @logger.add(nil, msg)
    assert_match(/some message \(pid:\d+\)\n/m, msg)
    assert_match(/another message \(pid:\d+\)\n/m, msg)
    assert_no_match(/\n *\(pid:/m, msg)

    msg = @logger.add(nil,"some message\nanother message\n\n")
    msg = @logger.add(nil, msg)
    assert_match(/some message \(pid:\d+\)\n/m, msg)
    assert_match(/another message \(pid:\d+\)\n/m, msg)
    assert_no_match(/\n *\(pid:/m, msg)
  end

end


class LoggerTest < Test::Unit::TestCase

  def setup
    @logger = Logger.new(nil)
  end

  def test_loaded_constant_is_true
    assert_equal(true, RawkLog::PATCHED_LOGGER)
  end

  def test_leaves_blank_lines_alone
    msg = @logger.format_message(nil, nil, nil, "\n\n")
    assert_equal("\n\n", msg)
  end

  def test_adds_only_newline_to_empty_string
    msg = @logger.format_message(nil, nil, nil, "")
    assert_equal("\n", msg)
    msg = @logger.format_message(nil, nil, nil, msg)
    assert_equal("\n", msg)
  end

  def test_adds_pid_to_line
    msg = @logger.format_message(nil, nil, nil, "some message")
    assert_match(/^some message \(pid:\d+\)\n$/m, msg)
  end

  def test_adds_pid_to_line_only_once
    msg = @logger.format_message(nil, nil, nil, "some message")
    msg = @logger.format_message(nil, nil, nil, msg)
    assert_match(/^some message \(pid:\d+\)\n$/m, msg)
  end

  def test_adds_pid_to_all_lines
    msg = @logger.format_message(nil, nil, nil, "some message\nanother message")
    msg = @logger.format_message(nil, nil, nil, msg)
    assert_match(/some message \(pid:\d+\)\n/m, msg)
    assert_match(/another message \(pid:\d+\)\n/m, msg)
    assert_no_match(/\n *\(pid:/m, msg)

    msg = @logger.format_message(nil, nil, nil, "some message\nanother message\n\n")
    msg = @logger.format_message(nil, nil, nil, msg)
    assert_match(/some message \(pid:\d+\)\n/m, msg)
    assert_match(/another message \(pid:\d+\)\n/m, msg)
    assert_no_match(/\n *\(pid:/m, msg)
  end

end
