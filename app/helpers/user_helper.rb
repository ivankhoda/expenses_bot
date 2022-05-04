module UserHelper
  def user_exists(username)
    puts username, 'username'
    user_exists = User.find_by_username(username)
  end
end
