if defined?(Logger)

  class Logger
    def format_message(severity, timestamp, progname, msg)
      # If a newline is necessary then create a new message ending with a newline.
      # Ensures that the original message is not mutated.
      msg = "#{msg}\n" unless msg[-1,1] == "\n"
      if msg !~ /\(pid\:/
        msg.gsub(/(\S.)$/, "\\1 (pid:#{$$})")
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
          message = "#{message}\n" unless message[-1,1] == "\n"
          if message !~ /\(pid\:/
            message.gsub(/(\S.)$/, "\\1 (pid:#{$$})")
          else
            message
          end
        end
      end

      alias_method :add_without_pid, :add
      alias_method :add, :add_with_pid

    end
  end

  module RawkLog
    PATCHED_BUFFERED_LOGGER = true
  end

end
