
class SessionsController < ApplicationController
  skip_before_action :authenticate_admin!

def create
  current_user = nil
  session[:user_id] = nil
  session[:email] = nil

  if params[:usr]
    # Decode user info string
    @userw = params[:usr]
    @decoded = Base64.decode64(@userw).split("|")
    @id = @decoded[0]
    @name = @decoded[1]
    @group = @decoded[2]
    @email = @decoded[3]
    @company = @decoded[4]
    @country = @decoded[5]

    # Find the user or create a new user if one doesn't exist
    current_user = MrUser.find_or_create_by(cr_id: @id) do |user|
        user.email = @email
        user.cr_id = @id
        user.name = @name
        user.user_group = @user_group
        user.company = @company
        user.country = @country
      end

    # Update the users email if it has changed
    if current_user[:email] != @email
      current_user[:email] = @email
      current_user.save
    end

    # Set session variables
    session[:user_id] = current_user.id  
    session[:email] = current_user.email
    session[:name] = current_user.name
    log_in current_user
  end

  # Send user to new code submission page
  redirect_to new_code_submission_path
end



def destroy
	session[:user_id] = nil
end

end
