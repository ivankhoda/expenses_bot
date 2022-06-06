module UserHelper
  def user_already_registered
    reply_with :message, text: 'You already registered in bot'
  end
end
