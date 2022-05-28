class UserController < ApplicationController
  def new
    @user = User.new
  end

  def create(user_params)
    @user = User.new(user_params)
    if @user.save
      render json: { message: 'You succesfully registred' }
    else
      render json: { error: @user.errors.messages }
    end
  end

  def show
    User.find_by_username(username: user_params[:username])
  end

  private

  def user_params
    puts params, 'parameteres'
    params.require(:user).permit(:username)
  end
end
