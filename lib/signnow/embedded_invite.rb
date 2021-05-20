module SN
  class EmbeddedInvite
    attr_accessor :document_id, :invites, :from_user_token

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    # Serializes this instance of {EmbeddedInvite} into a JSON document
    # @return [String]
    def to_json
      {
        invites: @invites
      }.to_json
    end

    # Deserialize a JSON document into an instance of {EmbeddedInvite}
    #
    # @param [String] str the JSON string to deserialize
    # @return [EmbeddedInvite]
    def self.from_json(str)
      self.new JSON.parse(str)
    end

    # Create a {EmbeddedInvite} in the SignNow system from this instance
    # @return [Boolean] true if successful
    def save
      headers = {
          content_type: :json,
          accept: :json,
          authorization: "Bearer #{@from_user_token}"
      }
      begin
        response = RestClient.post("#{SN.Settings.base_url}/v2/documents/#{@document_id}/embedded-invites", to_json, headers)
        body = JSON.parse(response.body, object_class: OpenStruct)

        invites.each do |invite|
          response_invite = body.data.detect { |i| i.email == invite.email }
          invite.id = response_invite.id
        end
        true
      rescue Exception => e
        puts e.inspect
        puts e.response
        false
      end
    end

    # Create a {EmbeddedInvite} in the SignNow system from this instance
    #
    # @param [Hash] attrs the attributes to create this {EmbeddedInvite} with
    # @return [EmbeddedInvite] nil if unsuccessful
    def self.create(attrs)
      invitation = self.new(attrs)
      invitation.save ? invitation : nil
    end

    # Creates a URL to a signing session for an invitee
    #
    # @param [Hash] params Parameters needed to create a signing link
    # @option params [String] :username the invitee's username
    # @option params [String] :password the invitee's password
    # @option params [String] :id the ID of the document in the signing session
    # @return [String] a URL to the signing session
    def generate_signing_link(params)
      raise ArgumentError, 'Missing params[:id]' if params[:id].nil?
      raise ArgumentError, 'Missing params[:document_id]' if params[:document_id].nil?

      headers = {
        content_type: :json,
        accept: :json,
        authorization: "Bearer #{@from_user_token}"
      }

      url = "#{SN.Settings.base_url}/v2/documents/#{params[:document_id]}/embedded-invites/#{params[:id]}/link"
      begin
        response = RestClient.post(url, { auth_method: 'none' }.to_json, headers)
        JSON.parse(response.body, object_class: OpenStruct).data.link
      rescue Exception => e
        puts e.inspect
        puts e.response
        false
      end
    end

    class Invite
      attr_accessor :id, :email, :role, :order, :auth_method

      def initialize(attrs = {})
        attrs.each do |key, value|
          self.instance_variable_set("@#{key}".to_sym, value)
        end
      end

      # Serializes this instance of {EmbeddedInvite::Invite} into a JSON document
      # @return [String]
      def to_json(attrs = {})
        {
            email: @email,
            role: @role,
            order: @order,
            auth_method: @auth_method
        }.to_json
      end

      # Deserialize a JSON document into an instance of {EmbeddedInvite::Invite}
      #
      # @param [String] str the JSON string to deserialize
      # @return [EmbeddedInvite::Invite]
      def self.from_json(str)
        self.new JSON.parse(str)
      end
    end
  end
end
