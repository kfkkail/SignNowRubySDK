require 'json'
require 'signnow'
require 'signnow/element'

module SN
  class TextElement < SN::Element
    attr_accessor :size, :font, :data, :line_height

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    def to_json(options = {})
      {
        size: @size,
        id: @id,
        x: @x,
        y: @y,
        page_number: @page_number,
        font: @font,
        data: data,
        line_height: @line_height,
        field_id: @field_id
      }.to_json
    end

    def self.from_json(str)
      self.new JSON.parse(str)
    end
  end
end