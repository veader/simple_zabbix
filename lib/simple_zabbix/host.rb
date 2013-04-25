class SimpleZabbix
  class Host < Base
    def items
      @_items ||= \
        begin
          assoc = ItemAssociation.new(self.client)
          assoc.parent_params = { hostids: self.hostid }
          assoc
        end
    end

    def host_groups
      @_host_groups ||= \
        begin
          assoc = HostGroupAssociation.new(self.client)
          assoc.parent_params = { hostids: self.hostid }
          assoc
        end
    end

  end # Host
end # SimpleZabbix