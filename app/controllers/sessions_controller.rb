
class SessionsController < ApplicationController
def create
  current_user = nil
  session[:user_id] = nil
  session[:email] = nil
  @userw = params[:usr]
  @decoded = Base64.decode64(@userw).split("|")
  @id = @decoded[0]
  @name = @decoded[1]
  @group = @decoded[2]
  @email = @decoded[3]
  @company = @decoded[4]
  @country = @decoded[5]

  current_user = MrUser.find_by(email: @email) 
  if current_user
    current_user = MrUser.find_by(email: @email)
    session[:user_id] = current_user.id  
    session[:email] = current_user.email
    log_in current_user
    redirect_to new_code_submission_path
  else 
    user = MrUser.create({email: @email, cr_id: @id, name: @name, user_group: @group, company: @company, country: @country})
    current_user = MrUser.find_by(email: @email) 
    session[:user_id] = current_user.id  
    session[:email] = current_user.email
    log_in current_user
    redirect_to new_code_submission_path
  end 
end



def destroy

	session[:user_id] = nil

end

end
