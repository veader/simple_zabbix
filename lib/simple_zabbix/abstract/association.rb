class SimpleZabbix
  class Association
    attr_accessor :client, :parent_params

    def initialize(client)
      self.client = client
    end

    # -----------------------------------------------------------------------
    # REQUIRED OVERRIDES
    def api_method; nil; end            # proper API method. eg: 'host.get'

    def default_search_param; nil; end  # eg: 'host'

    def derived_class; nil; end         # eg: Host

    def search_key_mappings; nil; end   # eg: { name: 'host' }
    # -----------------------------------------------------------------------


    # returns a single item
    def find(value)
      key = default_search_param
      where(key => value).first
    end

    # returns a collection
    def where(filters={})
      if filters.empty?
        params = { filter: self.parent_params } if parent_params
      else
        valid_filter_params = validate_filters(filters)
        valid_filter_params ||= {}
        valid_filter_params.merge!(self.parent_params) if parent_params
        params = { filter: valid_filter_params }
      end
      params ||= {}
      params.merge!(output: 'extend')
      results, error = self.client.query_api(api_method, params)
      # TODO: handle error

      results.collect do |o|
        obj = derived_class.new(o)
        obj.client = self.client
        obj
      end if error.nil?
    end

    # TODO: method missing for enumerable methods and call where w/o no params?
    def all
      where
    end

    def first
      where.first
    end

  protected
    def validate_filters(filters)
      valid = {}
      filters.each do |key, value|
        if search_key_mappings.keys.include?(key.to_sym)
          valid[search_key_mappings[key.to_sym]] = value
        else
          puts "Unknown filter parameter #{key}. Skipping..."
        end
      end

      valid
    end

  end # Association

end # SimpleZabbix