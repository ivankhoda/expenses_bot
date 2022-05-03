class ApplicationController < ActionController::Base
  include Telegram::Bot::UpdatesController::Session
end
