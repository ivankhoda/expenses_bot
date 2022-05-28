module UserHelper
  def fetch_user_name(data, search = 'username')
    return data[search] if data.fetch(search, false)

    data.each_key do |k|
      answer = user_name(data[k], search) if data[k].is_a? Hash
      return answer if answer
    end
    data.fetch(search)
  end

  def user_already_registered
    reply_with :message, text: 'You already registered in bot'
  end

  def current_user(username)
    User.find_by_username(username)
  end
end
