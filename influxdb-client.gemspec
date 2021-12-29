Gem::Specification.new do |s|
  s.name        = 'influxdb-client'
  s.version     = '0.0.2'
  s.summary     = 'client for influxdb'
  s.description = 'client for influxdb'
  s.authors     = ['James Carson']
  s.email       = 'jms.crsn@gmail.com'
  s.homepage    = "http://tmpurl.com"
  s.license     = 'MIT'
  s.files = [
    'lib/influx_db.rb',
    'lib/influx_db/v1.rb',
    'lib/influx_db/v1/client.rb',
    'lib/influx_db/v1/data_point.rb'
  ]
end
