require 'spec_helper'
require 'securerandom'

describe SN::Document do

  it 'has valid data for a new document when it has a filename and user token' do
    doc = SN::Document.new(filename: "#{SecureRandom.hex}.pdf", user_token: SecureRandom.hex)
    expect(doc.validate_new_doc_params!).to_not raise_error
  end

  describe 'with a free form invite' do
    it 'is fulfilled when all requests have a signature_id' do
      doc = SN::Document.new(requests: [{ 'signature_id' => SecureRandom.hex }, { 'signature_id' => SecureRandom.hex }])
      expect(doc.is_fulfilled?).to be_true
    end

    it 'is not fulfilled when any request has a null signature_id' do
      doc = SN::Document.new(requests: [{ 'signature_id' => SecureRandom.hex }, { 'signature_id' => nil }])
      expect(doc.is_fulfilled?).to be_false
    end

    it 'is not fulfilled when any request has an empty string signature_id' do
      doc = SN::Document.new(requests: [{ 'signature_id' => SecureRandom.hex }, { 'signature_id' => '' }])
      expect(doc.is_fulfilled?).to be_false
    end
  end

  describe 'with a role-based invite' do
    it 'is fulfilled when all field invites have a fulfilled status' do
      doc = SN::Document.new(field_invites: [
          { 'id' => '153dceec3dc7571f51f60dbeba7c8da0617fec2d', 'status' => 'fulfilled' },
          { 'id' => '153dceec3dc7571f51f60dbeba7c8da0617fec2x', 'status' => 'fulfilled' }
      ])

      expect(doc.is_fulfilled?).to be_true
    end

    it 'is unfulfilled when any field invite has an unfulfilled status' do
      doc = SN::Document.new(field_invites: [
          { 'id' => '153dceec3dc7571f51f60dbeba7c8da0617fec2d', 'status' => 'fulfilled' },
          { 'id' => '153dceec3dc7571f51f60dbeba7c8da0617fec2x', 'status' => 'unfulfilled' }
      ])

      expect(doc.is_fulfilled?).to be_false
    end
  end

  describe 'self.get' do
    it 'should raise an error when a document id is not provided' do
      expect { SN::Document.get(access_token: SecureRandom.hex) }.to raise_error
    end

    it 'should raise an error when a user token is not provided' do
      expect { SN::Document.get(id: SecureRandom.hex) }.to raise_error
    end
  end

  describe 'self.from_json' do
    before(:each) do
      @sample_json = File.open(File.join(__dir__, 'document.json')).read
    end

    it 'should deserialize text elements' do
      doc = SN::Document.from_json(@sample_json)
      expect(doc.texts.size).to be == 3
      expect(doc.texts.first).to be_kind_of(SN::TextElement)
    end

    it 'should deserialize signature elements' do
      doc = SN::Document.from_json(@sample_json)
      expect(doc.signatures.size).to be == 1
      expect(doc.signatures.first).to be_kind_of(SN::SignatureElement)
    end

    it 'should deserialize fields' do
      doc = SN::Document.from_json(@sample_json)
      expect(doc.fields.size).to be == 4
      expect(doc.fields.first).to be_kind_of(SN::Field)
    end
  end
end

