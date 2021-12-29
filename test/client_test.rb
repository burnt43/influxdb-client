require './test/initialize.rb'

module InfluxDb
  module Testing
    class ClientTest < InfluxDb::Testing::Test
      def test_build_write_command
        client_01 = InfluxDb::Client.new('local', 'fake_db', port: 8086, protocol: 'http')

        dp_01 = InfluxDb::DataPoint.new.tap do |d|
          d.measurement = 'meas_01'
          d.add_tag(:name, 'name_01')
          d.add_attr(:attr_01, 1)
          d.time = Time.parse('2021-01-01 12:00:00')
        end

        assert_equal(
          'curl -XPOST http://local:8086/write?db=fake_db --silent --data-binary "meas_01,name=name_01 attr_01=1 1609520400000000000"',
          client_01.send(:build_write_command, dp_01)
        )
      end

      def test_build_write_command_with_multiple_data_points
        client_01 = InfluxDb::Client.new('local', 'fake_db', port: 8086, protocol: 'http')

        dp_01 = InfluxDb::DataPoint.new.tap do |d|
          d.measurement = 'meas_01'
          d.add_tag(:name, 'name_01')
          d.add_attr(:attr_01, 1)
          d.time = Time.parse('2021-01-01 12:00:00')
        end

        dp_02 = InfluxDb::DataPoint.new.tap do |d|
          d.measurement = 'meas_01'
          d.add_tag(:name, 'name_01')
          d.add_attr(:attr_01, 2)
          d.time = Time.parse('2021-01-01 12:00:01')
        end
        
        assert_equal(
          %Q(curl -XPOST http://local:8086/write?db=fake_db --silent --data-binary "meas_01,name=name_01 attr_01=1 1609520400000000000\nmeas_01,name=name_01 attr_01=2 1609520401000000000"),
          client_01.send(:build_write_command, dp_01, dp_02)
        )
      end

      def test_parse_query_result
        client_01 = InfluxDb::Client.new('local', 'fake_db', port: 8086, protocol: 'http')

        sample_response_01 = %Q({"results":[{"statement_id":0,"series":[{"name":"memory_usage","columns":["time","name","physical","virtual"],"values":[["2021-12-29T16:55:51.953443786Z","recorder0",5000,1000000]]}]}]})
        result = client_01.send(:parse_query_result, sample_response_01)

        assert_equal(1, result.size)

        record = result[0]
        assert_equal('recorder0', record['name'])
        assert_equal(5_000, record['physical'])
        assert_equal(1_000_000, record['virtual'])
      end
    end
  end
end
