module UserHelper
  def user_exist(username)
    !User.find_by_username(username).nil?
  end

  def user_name(data, search = 'username')
    return data[search] if data.fetch(search, false)

    data.each_key do |k|
      answer = user_name(data[k], search) if data[k].is_a? Hash
      return answer if answer
    end
    data.fetch(search)
  end

  def create_user(username)
    user = User.new({ username: })
    if user.save
      reply_with :message, text: 'You succesfully registred'
    else
      reply_with :message, text: 'Something went wrong, check if username exists.'
    end
  end

  def current_user(username)
    User.find_by_username(username)
  end
end
