class FacebookService
  class << self
    def handle_message(sender_id, message)
      if message['text']
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
  end
end
