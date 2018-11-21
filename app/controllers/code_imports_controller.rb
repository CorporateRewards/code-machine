class CodeImportsController < ApplicationController
  def new
    @code_import = CodeImport.new
  end

  def create
    @file = params[:file]

    if valid_file?(@file)
      redirect_to codes_path
    else
      render :new
    end
  end


  def import 
    @file = params[:file]
    if Code.codes_in_file(@file)
      if Code.validate_file(@file)
        Code.import(@file)
        flash.notice = "Codes added successfully"
        redirect_to codes_path
      else
        flash[:error] = "Sorry, there was a problem importing your codes"
        redirect_to codes_path
      end
    end
  end
end
