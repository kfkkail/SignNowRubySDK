require 'rest-client'
require 'json'
require 'signnow'

module SN
  class Invitation
    attr_accessor :id, :document_id, :from_user_token, :from_user_email, :to_user_email

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end


    # Serializes this instance of {Invitation} into a JSON document
    # @return [String]
    def to_json
      { from: @from_user_email, to: @to_user_email }.to_json
    end


    # Creates this {Invitation} in the SignNow system.
    # @return [Boolean] true if successful
    def save
      headers = { content_type: :json, accept: :json, authorization: "Bearer #{@from_user_token}" }
      begin
        RestClient.post("#{SN.Settings.base_url}/document/#{document_id}/invite", to_json, headers)
        true
      rescue Exception => e
        puts e.inspect
        false
      end
    end

    # Creates an instance of {Invitation} from JSON. It does not call {#create} to persist.
    #
    # @param [String] str the JSON document to deserialize
    # @return [Invitation] an instance of {Document} built from str
    def self.from_json(str)
      self.new JSON.parse(str)
    end

    # Creates an {Invitation} in the SignNow system
    #
    # @param [Hash] attrs attributes for a new {Document} in SignNow
    # @option attrs [String] :filename A local path to the file to be created with this new {Document}
    # @option attrs [String] :user_token The access token of the owner of this {Document}
    # @return [Document] the new {Document}

    def self.create(attrs)
      invitation = self.new(attrs)
      invitation.save ? invitation : nil
    end
  end
end