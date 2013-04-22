dir = File.dirname(__FILE__)
Dir["#{dir}/simple_zabbix/abstract/*.rb"     ].each { |f| load(f) }
Dir["#{dir}/simple_zabbix/associations/*.rb" ].each { |f| load(f) }
Dir["#{dir}/simple_zabbix/*.rb"              ].each { |f| load(f) }

class SimpleZabbix
  def self.client
    Client.new
  end

end