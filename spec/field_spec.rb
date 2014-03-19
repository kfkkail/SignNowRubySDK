require 'spec_helper'
require 'securerandom'

describe SN::Field do
  describe 'should deserialize from JSON' do
    before(:each) do
      @sample_json = File.open(File.join(__dir__, 'field.json')).read
    end

    it 'should deserialize json_attributes into instance vars' do
      field = SN::Field.from_json(@sample_json)

      expect(field.label).to be == 'shoop da whoop'
      expect(field.page_number).to be == '0'
      expect(field.width).to be == '60'
      expect(field.x).to be == '307'
      expect(field.height).to be == '12'
      expect(field.required).to be_true
    end
  end
end
