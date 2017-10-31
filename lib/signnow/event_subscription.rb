module SN
  class EventSubscription
    attr_accessor :id, :event, :callback_url, :access_token

    def initialize(attrs = {})
      attrs.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    # Deserialize JSON into an instance of {EventSubscription}
    #
    # @param [String] str the JSON string to deserialize
    # @return [EventSubscription]
    def self.from_json(str)
      self.new JSON.parse(str)
    end

    # Serializes this instance of {EventSubscription} into JSON
    # @return [String]
    def to_json
      {
        id: @id,
        event: @event,
        callback_url: @callback_url,
        access_token: @access_token
      }.reject! { |k, v| v.nil? }.to_json
    end

    def self.create(attrs)
      sub = self.new(attrs)
      headers = {
        content_type: :json,
        accept: :json,
        authorization: "Bearer #{sub.access_token}"
      }
      begin
        RestClient.post("#{SN.Settings.base_url}/event_subscription", sub.to_json, headers)
        true
      rescue Exception => e
        puts e.inspect
        false
      end
    end

    # Retrieve an Event Subscription as a {EventSubscription}
    #
    # @param [String] access_token
    # @return [Token]
    def self.get(access_token)
      raise ArgumentError, 'Missing access_token' if access_token.nil?
      headers = { accept: :json, authorization: "Bearer #{access_token}" }
      events = []

      begin
        response = RestClient.get("#{SN.Settings.base_url}/event_subscription", headers)
        JSON.parse(response.body)['subscriptions'].each {|d|
          events << SN::EventSubscription.new(d)
        }
        events
      rescue Exception => e
        puts e.inspect
        false
      end
    end

    def destroy
      raise ArgumentError, 'Missing access_token' if @access_token.nil?
      headers = { authorization: "Bearer #{@access_token}" }
      begin
        RestClient.delete("#{SN.Settings.base_url}/event_subscription/#{@id}", headers)
        true
      rescue Exception => e
        puts e.inspect
        false
      end
    end
  end
end