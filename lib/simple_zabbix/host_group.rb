class SimpleZabbix
  class HostGroup < Base
    def hosts
      @_hosts ||= \
        begin
          assoc = HostAssociation.new(self.client)
          assoc.parent_params = { groupids: self.groupid }
          assoc
        end
    end

  end # Host
end # SimpleZabbix