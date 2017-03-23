class CodeSubmissionsController < ApplicationController
  # layout 'code_submission'
  def index
  	@codes = CodeSubmission.all
  end

  def list
    @codes = CodeSubmission.all
  end

  def new
   @code_submission = CodeSubmission.new
  end


  def create
    @code_submission = CodeSubmission.new(code_submission_params)
    @code_submission.user_id = params[:user_id]
    @code = @code_submission.code
    @code_submission[:user_id] = session[:user_id]
    @code_submission[:user_email] = session[:email]

    if @code_submission.save
      flash.notice = "Code '#{@code_submission.code}' submitted!"
      redirect_to new_code_submission_path
    else
      flash.now[:error] = "Sorry, there was a problem submitting the code '#{@code_submission.code}'"
      render :new
    end
    
  end

  def edit
    @code_submission = CodeSubmission.find(params[:id])
  end

  def update
    @code_submission = CodeSubmission.find(params[:id])
    if 
      @code_submission.update(code_submission_params)
      flash.notice = "Code '#{@code_submission.code}' Updated!"
      redirect_to edit_code_submission_path(@code_submission)
    else
      render :edit
    end
  end


  private


  def code_submission_params
    params.require(:code_submission).permit(:code, :user_id, :user_email, :code_id, :user_id)
  end


end