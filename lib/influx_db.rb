require 'json'
require 'pathname'
require 'time'

module InfluxDb
end

class String
  def influxdb_value_safe
    self.gsub(' ', '\ ')
  end
end

class Time
  def to_influxdb_timestamp
    strftime("%s%9N")
  end
end

lib_pathname = Pathname.new(__FILE__).parent

require lib_pathname.join('influx_db', 'client').to_s
require lib_pathname.join('influx_db', 'data_point').to_s
