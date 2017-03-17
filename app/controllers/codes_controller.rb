class CodesController < ApplicationController

  def index
  	@codes = Code.all
  end

  def new
  	@code = Code.new
  end

  def create
  	@code = Code.new(code_params)

		if @code.save
			redirect_to @code
		else
			render 'new'
		end
  end

  def edit
  	@code = Code.find(params[:id])
  end

  def show
  	@code = Code.find(params[:id])
  end

  def destroy
  	@code = Code.find(params[:id])
		@code.destroy

		redirect_to codes_path
  end


  private
  def code_params
			params.require(:code).permit(:id, :code, :programme_id)			
		end
end
