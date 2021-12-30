require './test/initialize.rb'

module InfluxDb
  module Testing
    class DataPointTest < InfluxDb::Testing::Test
      def test_to_influxdb_write_string
        dp_01 = InfluxDb::V1::DataPoint.new.tap do |d|
          d.measurement = 'memory_usage'
          d.add_tag(:name, 'recorder0')
          d.add_attr(:virtual, 1_000_000)
          d.add_attr(:physical, 5_000)
          d.time = Time.parse('2021-01-01 12:00:00')
        end

        assert_equal(
          'memory_usage,name=recorder0 virtual=1000000,physical=5000 1609520400000000000',
          dp_01.to_influxdb_write_string
        )
      end

      def test_to_influxdb_write_string_with_space_in_tag
        dp_01 = InfluxDb::V1::DataPoint.new.tap do |d|
          d.measurement = 'memory_usage'
          d.add_tag(:name, 'the powerful recorder')
          d.add_attr(:virtual, 2_000_000)
          d.add_attr(:physical, 10_000)
          d.time = Time.parse('2021-01-02 12:00:00')
        end

        assert_equal(
          'memory_usage,name=the\ powerful\ recorder virtual=2000000,physical=10000 1609606800000000000',
          dp_01.to_influxdb_write_string
        )
      end

      def test_to_influxdb_write_string_with_double_quote_in_tag
        dp_01 = InfluxDb::V1::DataPoint.new.tap do |d|
          d.measurement = 'memory_usage'
          d.add_tag(:name, '"accidental_double_quotes"')
          d.add_attr(:virtual, 100)
          d.add_attr(:physical, 200)
          d.time = Time.parse('2021-01-03 12:00:00')
        end

        assert_equal(
          'memory_usage,name=\"accidental_double_quotes\" virtual=100,physical=200 1609693200000000000',
          dp_01.to_influxdb_write_string
        )
      end
    end
  end
end
