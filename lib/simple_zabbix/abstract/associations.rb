class SimpleZabbix
  module Associations
    # NOTE: values stashed in parent_params hash are lazy eval'd at run-time
    def has_many(assoc, parent_params={})
      define_method(assoc.to_s) do
        instance_variable_get("@_#{assoc}") ||
        instance_variable_set("@_#{assoc}",
          begin
            evald_params = parent_params
            evald_params.map { |k,v| evald_params[k] = self.send(v) }
            Association.new(self.client, assoc, evald_params)
          end
        )
      end
    end

  end # Associations
end # SimpleZabbix