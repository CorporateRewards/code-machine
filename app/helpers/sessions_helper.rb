module SessionsHelper

  # Logs in the given user.
  def log_in(mruser)
    session[:user_id] = current_user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= MrUser.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end