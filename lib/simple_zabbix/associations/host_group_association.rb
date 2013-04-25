class SimpleZabbix
  class HostGroupAssociation < Association
    def api_method
      'hostgroup.get'
    end

    def default_search_param
      'name' # maps to 'host' below
    end

    def derived_class
      HostGroup
    end

    def translated_key_mappings
      { }
    end
  end

end