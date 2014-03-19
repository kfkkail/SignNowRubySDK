require 'json'
require 'signnow'

module SN
  class Element
    attr_accessor :id, :x, :y, :page_number, :field_id

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    def to_json(options = {})
      { id: @id, x: @x, y: @y, page_number: @page_number, field_id: @field_id }.to_json
    end

    def self.from_json(str)
      self.new JSON.parse(str)
    end
  end
end