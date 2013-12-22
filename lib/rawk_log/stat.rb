module RawkLog

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
      @count > 0 ? @sum/@count : @sum
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
      if count > 0
        if @new_log_format
          sprintf("%-55s %6d %7.2f %7d %7d %7d %7d %7d",key,count,(sum.to_f/1000),max,median,average,min,standard_deviation)
        else
          sprintf("%-55s %6d %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f",key,count,sum,max,median,average,min,standard_deviation)
        end
      else
          sprintf("%-55s %6d",key,0)
      end
    end

    def self.test
      stat = Stat.new(30)
      stat.add(5)
      stat.add(6)
      stat.add(8)
      stat.add(9)
      messages = [ 7==stat.median ? "median Success" : "median Failure" ]
      messages <<= (7==stat.average ? "average Success" : "average Failure")
      messages <<= (158==(stat.standard_deviation*100).round ? "std Success" : "std Failure")
      puts messages.join("\n")
      exit (messages.select{|m| m =~ /Failure/}.size)
    end

  end

end
