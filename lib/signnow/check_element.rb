require 'json'
require 'signnow'
require 'signnow/element'

module SN
  class CheckElement < SN::Element
    attr_accessor :width, :height

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    def to_json(options = {})
      {
        width: @width,
        height: @height,
        id: @id,
        x: @x,
        y: @y,
        page_number: @page_number,
        field_id: @field_id
      }.to_json
    end

    def self.from_json(str)
      self.new JSON.parse(str)
    end
  end
end