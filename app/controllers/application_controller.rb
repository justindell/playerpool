class ApplicationController < ActionController::Base
  protect_from_forgery

  def auth_user!
    redirect_to new_user_registration_path unless user_signed_in?
  end
end
