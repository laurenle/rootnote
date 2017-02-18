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
    if (text_body).upcase == 'YES'
      user_number.update_attribute(:verified, true)
      send_message(sender, "You're good to go! Text up to 5 images at a time to upload direct 2 RootNote")
    end
  end

  def self.upload_images_from_mms(from_number, sender_id, params)
    accepted_media = ['image/gif', 'image/png', 'image/jpeg']
    number_images = params["NumMedia"].to_i
    success = 0

    number_images.times do |i|
      break if i > 5
      upload = Upload.new
      upload.update_attribute(:user_id, sender_id)
      upload.file_from_url(params["MediaUrl#{i}"])
      success += 1 if upload.save
    end

    body = "Thanks for your message! Your number is #{from_number}. We successfully received #{success} images from you"
    send_message(from_number, body)
  end

  def self.is_registered_sender(sender)
    user_number = PhoneNumber.find_by number: sender
    user_number.present?
  end

  def self.is_verified_sender(sender)
    user_number = PhoneNumber.find_by number: sender
    user_number.present? and user_number.verified
  end

  def self.get_user_from_number(sender)
    user_number = PhoneNumber.find_by number: sender
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
