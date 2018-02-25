class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include SessionsHelper

protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up, keys: [:programme_id, :firstname, :lastname])
  	devise_parameter_sanitizer.permit(:edit, keys: [:programme_id, :firstname, :lastname])
  end
end
