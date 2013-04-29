class SimpleZabbix
  class Host < Base
    has_many :items, { hostids: :hostid }
    has_many :host_groups, { hostids: :hostid }

    def self.translated_key_mappings # for associations
      { name: 'host' }
    end

  end # Host
end # SimpleZabbix