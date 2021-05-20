module SN
  class Token
    attr_accessor :access_token, :token_type, :expires_in, :refresh_token, :scope

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    # Deserialize a JSON document into an instance of {Token}
    #
    # @param [String] str the JSON string to deserialize
    # @return [Token]
    def self.from_json(str)
      self.new JSON.parse(str)
    end

    # Retrieve an OAuth token as a {Token} to verify its validity
    #
    # @param [String] token the OAuth token to verify
    # @return [Token]
    def self.get(token)
      headers = { accept: :json, authorization: "Bearer #{token}" }

      begin
        response = RestClient.get("#{SN.Settings.base_url}/oauth2/token", headers)
        Token.from_json(response.body)
      rescue Exception => e
        puts e.inspect
        false
      end
    end

    # Creates an OAuth token for the SignNow user
    #
    # @param [Hash] params
    # @option params [String] :username the username of the SignNow user
    # @option params [String] :password the password of the SignNow user
    # @option params [String] :grant_type the grant type for the generated OAuth token
    # @option params [String] :scope the scope for the generated OAuth token
    # @return {Token}
    def self.create(params = {})
      payload = {
          username: params[:username],
          password: params[:password],
          grant_type: params[:grant_type],
          scope: params[:scope]
      }

      begin
        response = RestClient.post("#{SN.Settings.base_url}/oauth2/token", payload, authorization: "Basic #{SN.Settings.basic_authorization}")
        Token.from_json(response.body)
      rescue Exception => e
        puts e.inspect
        raise e
      end
    end
  end
end
