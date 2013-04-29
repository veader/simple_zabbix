class SimpleZabbix
  class Association
    attr_accessor :client, :parent_params, :built_up_params, :derived_class

    def initialize(client, assoc_name, parent_params={})
      self.client = client

      # remove "s". eg: hosts => host
      singular_assoc_name = \
        assoc_name.to_s.gsub(/s$/,'').split('_').collect(&:capitalize).join
      self.derived_class  = \
        SimpleZabbix.const_get(singular_assoc_name)
      self.parent_params = parent_params
    end

    # -----------------------------------------------------------------------

    # API method should be derived from the class name. eg: Host => "host.get"
    def api_method
      @_api_method ||= "#{method_from_class_name}.get"
    end

    def method_from_class_name # eg: Host => "host"
      @_method_from_class_name ||= \
        begin
          pieces = []
          str = self.derived_class.name.split(":").last
          while m = str.match(/[A-Z][a-z0-9]*/)
            pieces << m.to_s.downcase
            str = m.post_match
          end

          pieces.join
        end
    end

    def default_search_param # eg: Host => "host"
      @_default_search_param ||= \
        begin
          class_name = self.derived_class.name.split(":").last
          "#{class_name.downcase}"
        end
    end

    def translated_key_mappings
      return {} if !self.derived_class.respond_to?(:translated_key_mappings)
      self.derived_class.translated_key_mappings
    end

    def built_up_params
      @built_up_params ||= {}
      @built_up_params.merge!(self.parent_params || {}) if @built_up_params.empty?
      @built_up_params
    end

    # returns a single item
    def find(value)
      key = \
        if value.to_s =~ /^[0-9\.]*$/
          default_search_param + "id"
        else
          default_search_param
        end

      where(key => value).first
    end

    # returns a collection
    def where(filters={})
      self.built_up_params ||= {}
      filter_params = self.built_up_params[:filter] || {}

      if !filters.empty?
        translated_filter_params = translate_filters(filters) || {}
        params = { filter: filter_params.merge(translated_filter_params) }
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
    def translate_filters(filters)
      translated = {}
      filters.each do |key, value|
        if (translated_key_mappings || {}).keys.include?(key.to_sym)
          translated[translated_key_mappings[key.to_sym]] = value
        else
          # if key not found in translation table, use "as is"
          translated[key] = value
        end
      end

      translated
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