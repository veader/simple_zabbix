class SimpleZabbix
  class HostGroup < Base
    has_many :hosts, { groupids: :groupid}

  end # Host
end # SimpleZabbix