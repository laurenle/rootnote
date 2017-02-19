class Message
  @account_sid = Rails.application.config.twilio_sid
  @auth_token = Rails.application.config.twilio_token
  @twilio_number = Rails.application.config.twilio_number

  def self.get_twilio_number
    @twilio_number
  end

  def self.send_confirmation(recipient, user_email)
    censored_email = user_email.gsub(/(?<=.).*(?=\@)/, '*')
    body = "This number was recently registered to a RootNote account " + censored_email +
      ". Please respond YES if this was you."
    send_message(recipient, body)
  end

  def self.confirm_sender(sender, text_body)
    hyphenated_number = PhoneNumber.get_hyphenated_number(sender)
    user_number = PhoneNumber.find_by number: hyphenated_number
    if (text_body).upcase == 'YES'
      user_number.update_attribute(:verified, true)
      send_message(sender, "You're good to go! Text up to 5 images at a time to upload direct 2 RootNote")
    end
  end

  def self.upload_images_from_mms(from_number, sender_id, params)
    number_images = params["NumMedia"].to_i
    failures = 0
    number_images.times do |i|
      break if i > 5
      upload = Upload.new
      upload.update_attribute(:user_id, sender_id)
      upload.file_from_url(params["MediaUrl#{i}"])
      failures += 1 unless upload.save
    end
    if failures > 0      
      body = "There was an error uploading #{failures} of your messages. Please try again"
      send_message(from_number, body)
    end
  end

  def self.is_registered_sender(sender)
    hyphenated_number = PhoneNumber.get_hyphenated_number(sender)
    user_number = PhoneNumber.find_by number: hyphenated_number
    user_number.present?
  end

  def self.is_verified_sender(sender)
    hyphenated_number = PhoneNumber.get_hyphenated_number(sender)
    user_number = PhoneNumber.find_by number: hyphenated_number
    user_number.present? and user_number.verified
  end

  def self.get_user_from_number(sender)
    hyphenated_number = PhoneNumber.get_hyphenated_number(sender)
    user_number = PhoneNumber.find_by number: hyphenated_number
    user_number.user_id
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
