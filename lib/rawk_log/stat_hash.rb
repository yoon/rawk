require 'rawk_log/stat'

module RawkLog
  class StatHash

    def initialize
      @stats = Hash.new
    end

    def empty?
      @stats.empty?
    end

    def add(key,time)
      stat = @stats[key] || (@stats[key] = RawkLog::Stat.new(key))
      stat.add(time)
    end

    def print(args={:sort_by=>'key',:ascending=>true,:limit=>nil})
      values = @stats.values
      return Stat::DEFAULT_LABEL_SIZE if values.empty?
      order = (args[:ascending] || args[:ascending].nil?) ? 1 : -1
      values.sort! {|a,b| 
        as = a.send(args[:sort_by])
        bs = b.send(args[:sort_by])
        (as && bs) ? order*(as<=>bs) : 0
      }
      #values.sort! {|a,b| a.key<=>b.key}
      limit = args[:limit]
      if limit
        values = values[0,limit]
      end
      @label_size = values.collect{|v| v.key.size }.max
      @label_size = Stat::DEFAULT_LABEL_SIZE if @label_size < Stat::DEFAULT_LABEL_SIZE
      puts values[0].header(@label_size)
      for stat in values
        puts stat.to_s(@label_size)
      end
      @label_size
    end
  end
end

