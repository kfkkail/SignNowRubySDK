require 'json'
require 'signnow'

module SN
  class Field
    attr_accessor :id, :x, :y, :width, :height, :page_number, :role, :required, :type, :element_id, :field_id, :label

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    # Serializes this instance of {Field} into a JSON document
    # @return [String]
    def to_json(options = {})
      {
        id: @id,
        x: @x,
        y: @y,
        width: @width,
        height: @height,
        page_number: @page_number,
        role: @role,
        required: @required,
        type: @type,
        element_id: @element_id,
        field_id: @field_id,
        label: @label
      }.to_json
    end


    # Deserialize a JSON document into an instance of {Field}
    #
    # @param [String] str the JSON string to deserialize
    # @return [Field]
    def self.from_json(str)
      hash = JSON.parse(str)
      field = self.new hash

      hash['json_attributes'].each do |k ,v|
        field.send("#{k}=", v)
      end

      field
    end

    module FieldTypes
      SIGNATURE = 'signature'
      TEXT = 'text'
      INITIALS = 'initials'
      CHECKBOX = 'checkbox'
    end
  end
end


