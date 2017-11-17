require 'json'
require 'rest-client'
require 'signnow'

module SN
  class Document
    attr_accessor :id, :texts, :signatures, :checks, :fields, :updated, :requests, :roles, :field_invites

    attr_accessor :filename, :user_token

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end

      @texts ||= []
      @signatures ||= []
      @checks ||= []
      @requests ||= []
      @fields ||= []
      @roles ||= []
      @field_invites ||= []
    end


    # Validates whether this {Document} has valid attributes to save and throws an error otherwise.
    def validate_new_doc_params!
      raise InvalidStateError.new 'Missing document data' if @filename.to_s == '' || @user_token.to_s == ''
    end


    # Serializes this instance of {Document} into a JSON document
    # @return [String]
    def to_json
      {
        id: @id,
        texts: @texts,
        signatures: @signatures,
        checks: @checks,
        fields: @fields,
        updated: @updated,
        requests: @requests,
        field_invites: @field_invites,
        roles: @roles
      }.reject! { |k, v| v.nil? }.to_json
    end


    # Creates or updates this instance of {Document}. When an ID is present the message is forwarded to {#update},
    # otherwise the message is sent to {#create}.
    def save
      @id.to_s == '' ? create : update
    end


    # Checks to see if this {Document} has all required signatures from invitees. If the {Document} has requests
    # then it's considered free-form and we just check the signature_id attribute of those objects. If it has any
    # field_invites then the invitations are role-based and we check the status attribute of each of those objects.
    # @return [Boolean]
    def is_fulfilled?
      if @requests.any?
        @requests.all? { |r| r['signature_id'].to_s != '' }
      elsif @field_invites.any?
        @field_invites.all? { |f| f['status'] == 'fulfilled' }
      else
        true
      end
    end


    # Creates an instance of {Document} from JSON. It does not call {Document#create} to persist.
    #
    # @param [String] str the JSON document to deserialize
    # @return [Document] an instance of {Document} built from str
    def self.from_json(str)
      hash = JSON.parse(str)
      doc = self.new hash

      # need to create instances from JSON because the initialize methods of each class
      # don't understand how to parse the structure coming from the API server
      if hash['roles']
        doc.roles = hash['roles'].map { |r| SN::Role.from_json(r.to_json) }
      end

      if hash['texts']
        doc.texts = hash['texts'].map { |t| SN::TextElement.from_json(t.to_json) }
      end

      if hash['signatures']
        doc.signatures = hash['signatures'].map { |s| SN::SignatureElement.from_json(s.to_json) }
      end

      if hash['checks']
        doc.checks = hash['checks'].map { |c| SN::CheckElement.from_json(c.to_json) }
      end

      if hash['fields']
        doc.fields = hash['fields'].map { |f| SN::Field.from_json(f.to_json) }
      end

      doc
    end

    # Creates a {Document} in the SignNow system
    #
    # @param [Hash] attrs attributes for a new {Document} in SignNow
    # @option attrs [String] :filename A local path to the file to be created with this new {Document}
    # @option attrs [String] :user_token The access token of the owner of this {Document}
    # @return [Document] the new {Document}
    def self.create(attrs)
      doc = self.new(attrs)
      doc.save ? doc : nil
    end


    # Retrieves all the {Document}s for a user
    #
    # @param access_token [String] the access token of the user you want to retrieve {Document}s for
    # @return [Array<Document>] an array of {Document}
    def self.all(access_token)
      raise ArgumentError, 'Missing access_token' if access_token.nil?
      headers = { accept: :json, authorization: "Bearer #{access_token}" }
      docs = []

      begin
        response = RestClient.get("#{SN.Settings.base_url}/user/documentsv2", headers)
        JSON.parse(response.body).each { |d| docs << SN::Document.new(d) }
        docs
      rescue Exception => e
        puts e.inspect
        raise e
      end
    end


    # Retrieves a {Document} by id
    #
    # @param [Hash] params Parameters needed to retrieve a document
    # @option params [String] :id the document ID
    # @option params [String] :access_token the access token of the user who owns this document
    # @return [Document] the {Document} instance found for the provided ID
    def self.get(params)
      raise ArgumentError, 'Missing params[:access_token]' if params[:access_token].nil?
      raise ArgumentError, 'Missing params[:id]' if params[:id].nil?

      headers = { accept: :json, authorization: "Bearer #{params[:access_token]}" }

      begin
        response = RestClient.get("#{SN.Settings.base_url}/document/#{params[:id]}", headers)
        SN::Document.from_json(response.body)
      rescue Exception => e
        puts e.inspect
        raise e
      end
    end


    # Creates a URL to a signing session for an invitee
    #
    # @param [Hash] params Parameters needed to create a signing link
    # @option params [String] :username the invitee's username
    # @option params [String] :password the invitee's password
    # @option params [String] :id the ID of the document in the signing session
    # @return [String] a URL to the signing session
    def self.generate_signing_link(params)
      raise ArgumentError, 'Missing params[:id]' if params[:id].nil?
      raise ArgumentError, 'Missing params[:username]' if params[:username].nil?
      raise ArgumentError, 'Missing params[:password]' if params[:password].nil?

      scope = "document/#{params[:id]} document/#{params[:id]}/* user user/signature"
      restricted_access_token = Token.create(username: params[:username], password: params[:password], grant_type: 'password', scope: scope)
      url = "#{SN.Settings.signing_base_url}/dispatch?route=fieldinvite&document_id=#{params[:id]}&access_token=#{restricted_access_token.access_token}&mobileweb=mobileweb_only&use_signature_panel=1"
      if (params[:redirect_uri])
        redirect_url = URI.escape(params[:redirect_uri], '/:')
        url += "&redirect_uri=#{redirect_url}"
      end
      url
    end


    # Downloads a collapsed PDF representation of the document
    #
    # @param [Hash] params Parameters needed to download the {Document}
    # @option params [String] :id the ID of the {Document} to download
    # @option params [String] :access_token the access token of the owner of the {Document}
    # @return [Array] the collapsed PDF as a byte array
    def self.download(params)
      raise ArgumentError, 'Missing options[:access_token]' if params[:access_token].nil?
      raise ArgumentError, 'Missing options[:id]' if params[:id].nil?

      headers = { authorization: "Bearer #{params[:access_token]}" }

      begin
        response = RestClient.get("#{SN.Settings.base_url}/document/#{params[:id]}/download?type=collapsed", headers)
        response.body
      rescue Exception => e
        puts e.inspect
        nil
      end
    end

    private
      def create
        validate_new_doc_params!
        payload = { multipart: true, file: File.new(@filename, 'rb') }
        headers = { authorization: "Bearer #{@user_token}" }

        begin
          response = RestClient.post("#{SN.Settings.base_url}/document/fieldextract", payload, headers)
          @id = JSON.parse(response.body)['id']
          true
        rescue Exception => e
          puts e.inspect
          false
        end
      end

      def update
        headers = {
          content_type: :json,
          accept: :json,
          authorization: "Bearer #{@user_token}"
        }

        begin
          RestClient.put("#{SN.Settings.base_url}/document/#{@id}", to_json, headers)
          true
        rescue Exception => e
          puts e.inspect
          false
        end
      end
  end
end

