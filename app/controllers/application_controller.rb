class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def auth_user!
    redirect_to new_user_registration_path unless user_signed_in?
  end

  protected

  def configure_permitted_parameters
    [:first_name, :last_name, :team_name, :avatar, :avatar_file_name, :avatar_file_size, :avatar_content_type, :avatar_updated_at].each do |custom|
      devise_parameter_sanitizer.for(:sign_up) << custom
      devise_parameter_sanitizer.for(:account_update) << custom
    end
  end
end
