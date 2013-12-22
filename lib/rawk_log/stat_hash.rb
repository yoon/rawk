require 'rawk_log/stat'

module RawkLog
  class StatHash
    def initialize
      @stats = Hash.new
    end
    def add(key,time)
      stat = @stats[key] || (@stats[key] = RawkLog::Stat.new(key))
      stat.add(time)
    end
    def print(args={:sort_by=>'key',:ascending=>true,:limit=>nil})
      values = @stats.values
      order = (args[:ascending] || args[:ascending].nil?) ? 1 : -1
      values.sort! {|a,b| 
        as = a.send(args[:sort_by])
        bs = b.send(args[:sort_by])
        (as && bs) ? order*(as<=>bs) : 0
      }
      #values.sort! {|a,b| a.key<=>b.key}
      limit = args[:limit]
      for stat in values
        break if limit && limit<=0
        puts stat.to_s
        limit-=1 if limit
      end
    end
  end
end

