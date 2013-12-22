if defined? Logger

  class Logger
    def format_message(severity, timestamp, progname, msg)
      "#{msg} (pid:#{$$})\n"
    end
  end

end
