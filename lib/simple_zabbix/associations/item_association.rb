class SimpleZabbix
  class ItemAssociation < Association
    def api_method
      'item.get'
    end

    def default_search_param
      'name' # maps to 'host' below
    end

    def derived_class
      Item
    end

    def search_key_mappings
      { name: 'host' }
    end
  end

end