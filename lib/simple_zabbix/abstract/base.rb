class SimpleZabbix
  class Base
    extend Associations
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

    def id
      @_id ||= self.attributes["#{simple_name}id"]
    end

    def simple_name
      self.class.name.split(':').last.match(/[A-Z][a-z]*$/).to_s.downcase
    end

    def camelize(str)
      str.to_s.split('_').map { |p| p.capitalize }.join
    end

  end # Base
end # SimpleZabbix