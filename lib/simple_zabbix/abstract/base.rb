class SimpleZabbix
  class Base
    attr_accessor :attributes, :client

    def initialize(attributes={})
      self.attributes = attributes
    end

    def method_missing(method, *args, &block)
      question_regex = /\?$/
      mc = camelize(method)

      # proxy most of the missing methods through the attributes
      # NOTE: not sure why zabbix can't standardize attribute names... sigh
      if self.attributes.include?(method.to_s)
        self.attributes[method.to_s]
      elsif self.attributes.include?(mc)
        self.attributes[mc]
      elsif self.attributes.include?(mc.downcase)
        self.attributes[mc.downcase]
      else
        super # a MUST
      end
    end

    def camelize(str)
      str.to_s.split('_').map { |p| p.capitalize }.join
    end

  end # Base
end # SimpleZabbix