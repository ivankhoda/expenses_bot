class UserController < ApplicationController
  def new
    @user = User.new
  end

  def create(user_params)
    @user = User.new(user_params)
    if @user.save
      respond_with :message, text: 'You succesfully registred'
    else
      @user.errors.messages
    end
  end

  def show
    User.find_by_username(username: user_params[:username])
  end

  private

  def user_params
    params.require(:message).permit(:username)
  end
end
