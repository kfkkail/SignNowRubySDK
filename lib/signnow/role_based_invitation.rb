module SN
  class RoleBasedInvitation
    attr_accessor :document_id, :to, :from, :from_user_token, :cc, :subject, :message

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
      @to ||= []
      @cc ||= []
    end


    # Serializes this instance of {RoleBasedInvitation} into a JSON document
    # @return [String]
    def to_json
      {
        to: @to,
        from: @from,
        cc: @cc,
        subject: @subject,
        message: @message
      }.to_json
    end


    # Deserialize a JSON document into an instance of {RoleBasedInvitation}
    #
    # @param [String] str the JSON string to deserialize
    # @return [RoleBasedInvitation]
    def self.from_json(str)
      self.new JSON.parse(str)
    end


    # Create a {RoleBasedInvitation} in the SignNow system from this instance
    # @return [Boolean] true if successful
    def save
      headers = {
          content_type: :json,
          accept: :json,
          authorization: "Bearer #{@from_user_token}"
      }
      begin
        RestClient.post("#{SN.Settings.base_url}/document/#{@document_id}/invite?email=disable", to_json, headers)
        true
      rescue Exception => e
        puts e.inspect
        false
      end
    end

    # Create a {RoleBasedInvitation} in the SignNow system from this instance
    #
    # @param [Hash] attrs the attributes to create this {RoleBasedInvitation} with
    # @return [RoleBasedInvitation] nil if unsuccessful
    def self.create(attrs)
      invitation = self.new(attrs)
      invitation.save ? invitation : nil
    end


    class Recipient
      attr_accessor :email, :role, :role_id, :order

      def initialize(attrs = {})
        attrs.each do |key, value|
          self.instance_variable_set("@#{key}".to_sym, value)
        end
      end

      def to_json(attrs = {})
        {
            email: @email,
            role: @role,
            role_id: @role_id,
            order: @order
        }.to_json
      end

      def self.from_json(str)
        self.new JSON.parse(str)
      end
    end
  end
end

