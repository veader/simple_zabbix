class SimpleZabbix
  class Association
    attr_accessor :client, :parent_params, :built_up_params

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
      self.built_up_params ||= {}
      filter_params = self.built_up_params[:filter] || {}

      if filters.empty?
        params = { filter: filter_params.merge(self.parent_params || {}) }
      else
        valid_filter_params = validate_filters(filters) || {}
        valid_filter_params.merge!(self.parent_params || {})
        params = { filter: filter_params.merge(valid_filter_params) }
      end
      params ||= {}
      params.merge!(output: 'extend')

      self.built_up_params.merge!(params)

      self # return ourself so we can chain these calls...
    end

    def take(count=100)
      limit_params = { limit: count }
      self.built_up_params ||= {}
      self.built_up_params.merge!(limit_params)

      self # return ourself so we can chain these calls...
    end
    def limit(count); take(count); end

    # functionality not provided by the API :(
    # def skip(count=100)
    #   offset_params = {}
    # end
    # def offset(count); skip(count); end

    def method_missing(method, *args, &block)
      # look for method in Array/Enumerable
      # - for these methods, call where to make sure default query params are
      #       included and then execute the query
      if Array.instance_methods.include?(method.to_sym)
        where.execute_query.send(method, *args, &block)
      elsif method.to_s == 'all'
        where.execute_query
      else
        super # a MUST
      end
    end

  protected
    def validate_filters(filters)
      valid = {}
      filters.each do |key, value|
        if (search_key_mappings || {}).keys.include?(key.to_sym)
          valid[search_key_mappings[key.to_sym]] = value
        else
          puts "Unknown filter parameter #{key}. Skipping..."
        end
      end

      valid
    end

    def execute_query
      results, error = self.client.query_api(api_method, built_up_params)
      # TODO: handle error better

      final_results = \
        if error.nil?
          results.collect do |o|
            obj = derived_class.new(o)
            obj.client = self.client
            obj
          end
        else
          nil
        end

      # reset built_up_params
      self.built_up_params = {}

      final_results
    end

  end # Association

end # SimpleZabbix