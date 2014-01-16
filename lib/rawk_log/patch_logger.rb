if defined?(Logger)

  class Logger
    def format_message(severity, timestamp, progname, msg)
      if msg !~ /^\n*$/ && msg !~ /\(pid\:/
        "#{msg} (pid:#{$$})\n"
      else
        msg
      end
    end
  end

  module RawkLog
    PATCHED_LOGGER = true
  end

end

if defined?(ActiveSupport::BufferedLogger)

  module ActiveSupport

    class BufferedLogger

      def add_with_pid(severity, message = nil, progname = nil, &block)
        add_without_pid(severity) do
          message = (message || (block && block.call) || progname).to_s
          # If a newline is necessary then create a new message ending with a newline.
          # Ensures that the original message is not mutated.
          message = "#{message}\n" unless message[-1] == ?\n
          if message !~ /^\n*$/ && message !~ /\(pid\:/
            message.gsub(/\n/, " (pid:#{$$})\n")
          else
            message
          end
        end
      end

      alias_method_chain :add, :pid

    end
  end

  module RawkLog
    PATCHED_BUFFERED_LOGGER = true
  end

end
