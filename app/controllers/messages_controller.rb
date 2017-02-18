class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :require_login

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    accepted_media = ['image/gif', 'image/png', 'image/jpeg']
    number_images = params["NumMedia"].to_i

    success = 0
    number_images.times do |i|
      break if i > 5
      success += 1 if accepted_media.include? params["MediaContentType#{i}"]
    end
    boot_twilio
    sms = @client.messages.create(
      from: Rails.application.config.twilio_number,
      to: from_number,
      body: "Thanks for your message! Your number is #{from_number}. We successfully received #{success} images from you"
    )
  end

  private

  def boot_twilio
    account_sid = Rails.application.config.twilio_sid
    auth_token = Rails.application.config.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end