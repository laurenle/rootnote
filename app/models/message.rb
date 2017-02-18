class Message
  def self.confirm_recipient(phone_number)
    # TODO
  end

  def self.boot_twilio
    account_sid = Rails.application.config.twilio_sid
    auth_token = Rails.application.config.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
