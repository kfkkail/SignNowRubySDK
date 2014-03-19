require 'json'
require 'rest-client'
require 'base64'
require 'signnow'

module SN
  class User
    attr_accessor :id, :first_name, :last_name, :emails, :password, :access_token

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end

      @emails ||= []
    end

    def email
      @email.to_s == '' ? @emails.first.to_s : @email
    end

    def email=(str)
      @email = str
    end

    # Serializes this instance of {Field} into a JSON document
    # @return [String]
    def to_json
      {
        id: @id,
        first_name: @first_name,
        last_name: @last_name,
        email: @email,
        emails: @emails,
        password: @password,
        access_token: @access_token
      }.to_json
    end

    # Validates if this instance is valid for creating a new user
    def validate!
      raise InvalidStateError.new 'Missing user data' if @email.to_s == '' || @password.to_s == ''
    end


    # Create a new user in the SignNow system from this instance of {User}
    # @return [Boolean] true if successful
    def save
      validate!
      encoded = Base64.strict_encode64(SN.Settings.client_id + ':' + SN.Settings.client_secret)
      headers = {
        content_type: :json,
        accept: :json,
        authorization: "Basic #{encoded}"
      }

      begin
        response = RestClient.post("#{SN.Settings.base_url}/user", to_json, headers)
        json = JSON.parse(response.body)
        @id = json['id']
        @access_token = json['access_token']
        true
      rescue Exception => e
         puts e.inspect
         false
      end
    end


    # Retrieve an {User} by their OAuth token
    #
    # @param [String] access_token the OAuth token of the user to find
    # @return [User]
    def self.get(access_token)
      headers = { accept: :json, authorization: "Bearer #{access_token}" }

      begin
        response = RestClient.get("#{SN.Settings.base_url}/user", headers)
        User.from_json(response.body)
      rescue Exception => e
        puts e.inspect
        false
      end
    end


    # Deserialize a JSON document into an instance of {User}
    #
    # @param [String] str the JSON string to deserialize
    # @return [User]
    def self.from_json(str)
      self.new JSON.parse(str)
    end


    # Creates a {User} in the SignNow system
    #
    # @param [Hash] attrs attributes for a new {User} in SignNow
    # @option attrs [String] :email the e-mail of the new user
    # @option attrs [String] :password the password of the new user
    # @option attrs [String] :first_name the first name of the new user
    # @option attrs [String] :last_name the last name of the new user
    # @return [User]
    def self.create(attrs)
      user = self.new(attrs)
      user.save ? user : nil
    end
  end
end

