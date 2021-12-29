module InfluxDb
  class DataPoint
    def initialize
      @measurement = nil
      @tags        = {}
      @attrs       = {}
      @time        = nil
    end

    def measurement=(value)
      @measurement = value
    end

    def add_tag(name, value)
      @tags[name.to_sym] = value
    end

    def add_attr(name, value)
      @attrs[name.to_sym] = value
    end

    def time=(value)
      @time = value
    end

    def to_influxdb_write_string
      StringIO.new.tap do |s|
        s.print(@measurement)

        @tags.each do |name, value|
          s.print(',')
          s.print(name)
          s.print('=')
          s.print(value.influxdb_value_safe)
        end

        s.print(' ')

        @attrs.each_with_index do |(name, value), index|
          s.print(',') unless index.zero?
          s.print(name)
          s.print('=')
          s.print(value)
        end

        s.print(' ')

        s.print(time_as_influxdb_timestamp)
      end.string
    end

    private

    def time_as_influxdb_timestamp
      return unless @time

      if @time.is_a?(String) || @time.is_a?(Integer)
        @time
      else
        @time&.to_influxdb_timestamp
      end
    end
  end
end
