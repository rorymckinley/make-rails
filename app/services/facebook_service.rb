class FacebookService
  class << self
    def handle_message(sender_id, message)
      if message['text'] and message['text'] =~ /Show me (.+)!/
        gadgets = fetch_root_gadgets($1)
        transmit(sender_id, gadgets.join("\n"))
      elsif message['text']
        echo_message(sender_id, message)
      end
    end

    def echo_message(receiver_id, message)
      data = {
        recipient: {id: receiver_id},
        message:   {text: message['text']}
      }

      HTTParty.post("https://graph.facebook.com/v2.6/me/messages",
        body:    data.to_json,
        query:   {access_token: page_access_token},
        headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    private
    def page_access_token
      Settings.facebook.page_access_token
    end

    def fetch_root_gadgets(make)
      p root_client.list_gadget_models
      products = root_client.list_gadget_models.select { |data| data["make"] == make }
      products.map { |data| data["name"] }
    end

    def root_client
      Root::Insurance::Client.new(Settings.root.app_id, Settings.root.app_secret)
    end

    def transmit(receiver_id, message)
      data = {
        recipient: {id: receiver_id},
        message:   {text: message}
      }

      HTTParty.post("https://graph.facebook.com/v2.6/me/messages",
        body:    data.to_json,
        query:   {access_token: page_access_token},
        headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end
  end
end
