class Message
  @account_sid = Rails.application.config.twilio_sid
  @auth_token = Rails.application.config.twilio_token
  @twilio_number = Rails.application.config.twilio_number

  def self.send_confirmation(recipient, user_email)
    censored_email = user_email.gsub(/(?<=.).*(?=\@)/, '*')
    body = "This number was recently registered to a RootNote account " + censored_email +
      ". Please respond YES if this was you."
    send_message(recipient, body)
  end

  def self.confirm_sender(sender, text_body)
    user_number = PhoneNumber.find_by number: sender
    if (text_body) == 'YES'
      user_number.update_attribute(:verified, true)
      send_message(sender, "You're good to go! Text up to 5 images at a time to upload direct 2 RootNote")
    end
  end

  def self.is_registered_sender(sender)
    user_number = PhoneNumber.find_by number: sender
    user_number.present?
  end

  def self.is_verified_sender(sender)
    user_number = PhoneNumber.find_by number: sender
    user_number.present? and user_number.verified
  end

  def self.send_message(recipient, text_body)
    @twilio_client = boot_twilio
    @twilio_client.account.sms.messages.create(
      :from => @twilio_number,
      :to => recipient,
      :body => text_body
    )
  end

  def self.boot_twilio
    @client = Twilio::REST::Client.new @account_sid, @auth_token
  end
end
