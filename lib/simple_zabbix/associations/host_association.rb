class SimpleZabbix
  class HostAssociation < Association
    def api_method
      'host.get'
    end

    def default_search_param
      'name' # maps to 'host' below
    end

    def derived_class
      Host
    end

    def search_key_mappings
      { name: 'host' }
    end
  end

end