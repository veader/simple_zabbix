class SimpleZabbix
  class Host < Base
    def items
      @_items ||= \
        begin
          assoc = ItemAssociation.new(self.client)
          assoc.parent_params = { host: self.host }
          assoc
        end
    end

  end # Host
end # SimpleZabbix