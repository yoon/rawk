require "rawk_log/version"

# Don't load automatically
#require "rawk_log/command"

if defined?(ActiveSupport::BufferedLogger)
  require "rawk_log/patch_logger"
end
if defined?(ActiveSupport::BufferedLogger)
  require "rawk_log/patch_activesupport_bufferedlogger"
end

module RawkLog
  # Everything loaded in requires above
end
