require 'json'


module SN
  class Role
    attr_accessor :unique_id, :signing_order, :name

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    def to_json(attrs = {})
      {
          unique_id: @unique_id,
          signing_order: @signing_order,
          name: @name
      }
    end

    def self.from_json(str)
      self.new JSON.parse(str)
    end

  end
end
