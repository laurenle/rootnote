class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :require_login

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    accepted_media = ['image/gif', 'image/png', 'image/jpeg']
    number_images = params["NumMedia"].to_i

    if Message.is_verified_sender(from_number)
      success = 0
      number_images.times do |i|
        break if i > 5
        success += 1 if accepted_media.include? params["MediaContentType#{i}"]
      end
      @client = Message.boot_twilio
      sms = @client.messages.create(
        from: Rails.application.config.twilio_number,
        to: from_number,
        body: "Thanks for your message! Your number is #{from_number}. We successfully received #{success} images from you"
      )
    elsif Message.is_registered_sender(from_number)
      Message.confirm_sender(from_number, message_body)
    end
  end
end