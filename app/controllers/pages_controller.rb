class PagesController < ApplicationController

def show

end

def home

end


def index

end


private
def valid_page?
  File.exist?(Pathname.new(Rails.root + "app/views/pages/#{params[:page]}.html.erb"))
end
end
