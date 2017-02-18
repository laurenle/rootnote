class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :require_login

  def reply
    message_body = params["Body"]
    from_number = params["From"]

    if Message.is_verified_sender(from_number)
      sender_id = Message.get_user_from_number(from_number)
      Message.upload_images_from_mms(from_number, sender_id, params)
    elsif Message.is_registered_sender(from_number)
      Message.confirm_sender(from_number, message_body)
    end
  end
end