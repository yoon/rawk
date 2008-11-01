#!/usr/bin/env ruby
##Rail's Analyzer With Klass
#run the following to view help:
#ruby rawk.rb -?
require 'date'
class Stat
  def initialize(key)
    @key=key
    @min = nil
    @max = nil
    @sum = 0
    @sum_squares = 0
    @count = 0
    @values = []
  end
  def add(value)
    @new_log_format = !value.is_a?(Float)
    value=1.0*value
    @count+=1
    @min = value unless @min
    @min = value if value<@min
    @max = value unless @max
    @max = value if value>@max
    @sum += value
    @sum_squares += value*value
    @values << value
  end
  def key
    @key
  end
  def count
    @count
  end
  def sum
    @sum
  end
  def min
    @min
  end
  def max
    @max
  end
  def average
    @sum/@count
  end
  def median
    return nil unless @values
    l = @values.length
    return nil unless l>0
    @values.sort!
    return (@values[l/2-1]+@values[l/2])/2 if l%2==0
    @values[(l+1)/2-1]
  end
  def standard_deviation
    return 0 if @count<=1
    Math.sqrt((@sum_squares - (@sum*@sum/@count))/ (@count) )
  end
  def to_s
    if @new_log_format
      sprintf("%-45s %6d %7.2f %7d %7d %7d %7d %7d",key,count,(sum.to_f/1000),max,median,average,min,standard_deviation)
    else
      sprintf("%-45s %6d %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f",key,count,sum,max,median,average,min,standard_deviation)
    end
  end
  def self.test
    stat = Stat.new(30)
    stat.add(5)
    stat.add(6)
    stat.add(8)
    stat.add(9)
    puts 7==stat.median ? "median Success" : "median Failure"
    puts 7==stat.average ? "average Success" : "average Failure"
    puts 158==(stat.standard_deviation*100).round ? "std Success" : "std Failure"
  end
end
class StatHash
  def initialize
    @stats = Hash.new
  end
  def add(key,time)
    stat = @stats[key] || (@stats[key] = Stat.new(key))
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

class Rawk
  VERSION = 1.2
  HEADER                = "Request                                        Count     Sum     Max  Median     Avg     Min     Std"
  HEADER_NEW_LOG_FORMAT = "Request                                        Count  Sum(s)     Max  Median     Avg     Min     Std"
  HELP = "\nRAWK - Rail's Analyzer With Klass v#{VERSION}\n"+
  "Created by Chris Hobbs of Spongecell, LLC\n"+
  "This tool gives statistics for Ruby on Rails log files. The times for each request are grouped and totals are displayed. "+
  "If process ids are present in the log files then requests are sorted by ActionController actions otherwise requests are grouped by url. "+
  "By default total request times are used for comparison but database time or render time can be used by specifying the correct flag. "+
  "The log file is read from standard input unless the -f flag is specified.\n\n"+
  "The options are as follows:\n\n"+
  "  -?  Display this help.\n\n"+
  "  -d  Use DB times as data points. These times are found after 'DB:' in the log file. This overrides the default behavior of using the total request time.\n\n"+
  "  -f <filename> Use the specified file instead of standard input.\n\n"+
  "  -h  Display this help.\n\n"+
  "  -r  Use Render times as data points. These times are found after 'Rendering:' in the log file. This overrides the default behavior of using the total request time.\n\n"+
  "  -s <count> Display <count> results in each group of data.\n\n"+
  "  -t  Test\n\n"+
  "  -u  Group requests by url instead of the controller and action used. This is the default behavior if there is are no process ids in the log file.\n\n"+
  "  -w <count> Display the top <count> worst requests.\n\n"+
  "  -x <date> Date (inclusive) to start parsing in 'yyyy-mm-dd' format.\n\n"+
	"  -y <date> Date (inclusive) to stop parsing in 'yyyy-mm-dd' format.\n\n"+
  "To include process ids in your log file, add this to environment.rb:\n\n"+
  "  class Logger\n"+
  "    def format_message(severity, timestamp, progname, msg)\n"+
  "      \"\#{msg} (pid:\#{$$})\\n\"\n"+
  "    end\n"+
  "  end\n"+
  "\n"+
  "This software is Beerware, if you like it, buy yourself a beer.\n"+
  "\n"+
  "Example usage:\n"+
  "    ruby rawk.rb < production.log\n"
  
  def initialize
    @start_time = Time.now
    build_arg_hash
    if @arg_hash.keys.include?("?") || @arg_hash.keys.include?("h")
      puts HELP
    elsif @arg_hash.keys.include?("t")
      Stat.test
    else
      init_args
      build_stats
      print_stats
    end
  end
  def build_arg_hash
    @arg_hash = Hash.new
    last_key=nil
    for a in $*
      if a.index("-")==0 && a.length>1
        a[1,1000].scan(/[a-z]|\?/).each {|c| @arg_hash[last_key=c]=nil}
        @arg_hash[last_key] = a[/\d+/] if last_key
      elsif a.index("-")!=0 && last_key
        @arg_hash[last_key] = a
      end
    end
    #$* = [$*[0]]
  end
  def init_args
    @sorted_limit=20
    @worst_request_length=20
    @force_url_use = false
    @db_time = false
    @render_time = false
    @input = $stdin
    keys = @arg_hash.keys
    @force_url_use = keys.include?("u")
    @db_time = keys.include?("d")
    @render_time = keys.include?("r")
    @worst_request_length=(@arg_hash["w"].to_i) if @arg_hash["w"]
    @sorted_limit = @arg_hash["s"].to_i if @arg_hash["s"]
    @input = File.new(@arg_hash["f"]) if @arg_hash["f"]
    @from =(Date.parse(@arg_hash["x"])) if @arg_hash["x"]
    @to =(Date.parse(@arg_hash["y"])) if @arg_hash["y"]
  end
  def build_stats
    @stat_hash = StatHash.new
    @total_stat = Stat.new("All Requests")
    @worst_requests = []
    last_actions = Hash.new
    while @input.gets
      if $_.index("Processing ")==0
        action = $_.split[1]
        pid = $_[/\(pid\:\d+\)/]
        date = Date.parse($_[/(?:19|20)[0-9]{2}-(?:0[1-9]|1[012])-(?:0[1-9]|[12][0-9]|3[01])/])
        datetime = $_[/(?:19|20)[0-9]{2}-(?:0[1-9]|1[012])-(?:0[1-9]|[12][0-9]|3[01]) (?:[0-1][0-9]|2[0-3]):(?:[0-5][0-9]|60):(?:[0-5][0-9]|60)/]
        last_actions[pid]=action if pid
        next
      end
      next unless $_.index("Completed in")==0
      pid = key = nil
      #get the pid unless we are forcing url tracking
      pid = $_[/\(pid\:\d+\)/] if !@force_url_use
      key = last_actions[pid] if pid
      time = 0.0
      
      # Old: Completed in 0.45141 (2 reqs/sec) | Rendering: 0.25965 (57%) | DB: 0.06300 (13%) | 200 OK [http://localhost/jury/proposal/312]
      # New:  Completed in 100ms (View: 40, DB: 4) 
      unless defined? @new_log_format
        @new_log_format = $_ =~ /Completed in \d+ms/ 
      end
      
      if @new_log_format
        if @db_time
          time_string = $_[/DB: \d+/]
        elsif @render_time
          time_string = $_[/View: \d+/]
        else
          time_string = $_[/Completed in \d+ms/]
        end
        time_string = time_string[/\d+/] if time_string
        time = time_string.to_i if time_string
      else
        if @db_time
          time_string = $_[/DB: \d+\.\d+/]
        elsif @render_time
          time_string = $_[/Rendering: \d+\.\d+/]
        else
          time_string = $_[/Completed in \d+\.\d+/]
        end
        time_string = time_string[/\d+\.\d+/] if time_string
        time = time_string.to_f if time_string
      end
      
      
      #if pids are not specified then we use the url for hashing
      #the below regexp turns "[http://spongecell.com/calendar/view/bob]" to "/calendar/view"
      key = ($_[/\[\S+\]/].gsub(/\S+\/\/(\w|\.)*/,''))[/\/\w*\/?\w*/] unless key
      if (@from.nil? or @from <= date) and (@to.nil? or @to >= date) # date criteria here
        @stat_hash.add(key,time)
        @total_stat.add(time)
        if @worst_requests.length<@worst_request_length || @worst_requests[@worst_request_length-1][0]<time
          @worst_requests << [time,%Q(#{datetime} #{$_})]
          @worst_requests.sort! {|a,b| (b[0] && a[0]) ? b[0]<=>a[0] : 0}
          @worst_requests=@worst_requests[0,@worst_request_length]
        end
      end
    end
  end
  def print_stats
    @header ||= @new_log_format ? HEADER_NEW_LOG_FORMAT : HEADER
    puts "Printing report for #{@db_time ? 'DB' : @render_time ? 'render' : 'total'} request times#{@from ? %Q( from #{@from.to_s}) : ""}#{@to ? %Q( through #{@to.to_s}) : ""}"
    puts "--------"
    puts @header
    puts @total_stat.to_s
    puts "--------"
    @stat_hash.print()
    puts "\nTop #{@sorted_limit} by Count"
    puts @header
    @stat_hash.print(:sort_by=>"count",:limit=>@sorted_limit,:ascending=>false)
    puts "\nTop #{@sorted_limit} by Sum of Time"
    puts @header
    @stat_hash.print(:sort_by=>"sum",:limit=>@sorted_limit,:ascending=>false)
    puts "\nTop #{@sorted_limit} Greatest Max"
    puts @header
    @stat_hash.print(:sort_by=>"max",:limit=>@sorted_limit,:ascending=>false)
    puts "\nTop #{@sorted_limit} Least Min"
    puts @header
    @stat_hash.print(:sort_by=>"min",:limit=>@sorted_limit)
    puts "\nTop #{@sorted_limit} Greatest Median"
    puts @header
    @stat_hash.print(:sort_by=>"median",:limit=>@sorted_limit,:ascending=>false)
    puts "\nTop #{@sorted_limit} Greatest Standard Deviation"
    puts @header
    @stat_hash.print(:sort_by=>"standard_deviation",:limit=>@sorted_limit,:ascending=>false)
    puts "\nWorst Requests"
    @worst_requests.each {|w| puts w[1].to_s}
    puts "\nCompleted report in #{(Time.now.to_i-@start_time.to_i)/60.0} minutes -- spongecell"
  end
end

Rawk.new
