class ApplicationController < ActionController::Base
  include UserHelper
  include Telegram::Bot::UpdatesController::Session

  protect_from_forgery with: :null_session
end
