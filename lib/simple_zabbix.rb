require 'simple_zabbix/version'
require 'simple_zabbix/client'

# require_relative './simple_zabbix/client'
# require_relative './simple_zabbix/version'

class SimpleZabbix

  def self.client
    Client.new
  end

end