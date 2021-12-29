module InfluxDb
  module V1
    class Client
      def initialize(host, database, port: 8086, protocol: 'http')
        @host     = host
        @database = database
        @port     = port
        @protocol = protocol
      end

      def write(*data_points)
        shell_string = build_write_command(*data_points)
        raw_result = %x[#{shell_string}]
      end

      def query(query_string)
        execute_query(query_string)
      end

      private

      def build_write_command(*data_points)
        curl_data_binary_string = data_points.map(&:to_influxdb_write_string).join("\n")

        "curl -XPOST " \
        "#{@protocol}://#{@host}:#{@port}/write?db=#{@database} " \
        "--silent --data-binary \"#{curl_data_binary_string}\""
      end

      def build_query_command(query_string)
        "curl -XPOST " \
        "#{@protocol}://#{@host}:#{@port}/query?db=#{@database} " \
        "--silent --data-urlencode 'q=#{query_string}'"
      end

      def execute_query(query_string)
        shell_string = build_query_command(query_string)
        raw_result = %x[#{shell_string}]
        parse_query_result(raw_result)
      end

      def parse_query_result(raw_result)
        json = JSON.parse(raw_result)

        data = json.dig('results', 0, 'series', 0)
        return [] unless data

        column_names = data['columns']
        values = data['values']

        values.map do |value_array|
          Hash[column_names.zip(value_array)]
        end
      end
    end
  end
end
