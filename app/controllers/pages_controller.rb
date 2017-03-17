class PagesController < ApplicationController

def show
 # if valid_page? 
 #   render template: "pages/#{params[:page]}"
 # else
 #   render file: "public/404.html", status: :not_found
 # end

 if params[:usr]
 	session = {}
 	@userw = params[:usr]
 	@decoded = Base64.decode64(@userw).split("|")
 	@id = @decoded[0]
 	@name = @decoded[1]
 	@group = @decoded[2]
 	@email = @decoded[3]
 	@company = @decoded[4]
 	@country = @decoded[5]
 	session[:name] = @name
 	session[:user] = @id
	session[:user_id] = @id

	session[:group] = @group
	session[:email] = @email
	session[:company] = @company
	session[:country] = @country
	flash[:message] = "Data was saved successfully"
 else
 	@userw = "not working"
 end
end

def home
	session = {}
 if params[:usr]
 	session = {}
 	@userw = params[:usr]
 	@decoded = Base64.decode64(@userw).split("|")
 	@id = @decoded[0]
 	@name = @decoded[1]
 	@group = @decoded[2]
 	@email = @decoded[3]
 	@company = @decoded[4]
 	@country = @decoded[5]
 	session[:name] = @name
 	session[:user] = @id
	session[:user_id] = @id

	session[:group] = @group
	session[:email] = @email
	session[:company] = @company
	session[:country] = @country
	flash[:message] = "Data was saved successfully"
 else
 	@userx = "not working"
 end
end


def index

 if params[:usr]
 	@user = "working"
 else
 	@user = params[:usr]
 end
end
 	def identify_user
		@user = params[:usr]
	end

private
def valid_page?
  File.exist?(Pathname.new(Rails.root + "app/views/pages/#{params[:page]}.html.erb"))
end
end
