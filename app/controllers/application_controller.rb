class ApplicationController < ActionController::Base
  include Telegram::Bot::UpdatesController::Session

  protect_from_forgery with: :null_session
end
