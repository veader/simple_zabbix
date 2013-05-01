class SimpleZabbix
  module Associations
    # NOTE: values stashed in parent_params hash are lazy eval'd at run-time
    def has_many(assoc, parent_params={})
      define_method(assoc.to_s) do
        instance_variable_get("@_#{assoc}") ||
        instance_variable_set("@_#{assoc}",
          begin
            params = parent_params.dup
            params.map { |k,v| params[k] = attributes[v.to_s] }
            Association.new(client, assoc, params)
          end
        )
      end
    end

  end # Associations
end # SimpleZabbix