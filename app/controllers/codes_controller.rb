class CodesController < ApplicationController

  def code
    @code ||= Code.find(params[:id])
  end

  helper_method :code
  def index
    @codes = Code.all
  end

  def new
    @code = Code.new
  end

  def create
    @code = Code.new(code_params)

    if @code.save
      redirect_to @code, notice: "Code added successfully"
    else
      render 'new', notice: "Something went wrong, please try again"
    end
  end

  def edit

  end

  def update
    code
    if code.update(code_params)
       redirect_to code, notice: 'Code was successfully updated.'
     else
       render :edit
     end
  end

  def show
    # @code = Code.find(params[:id])
  end

  def destroy
    code
    code.destroy

    redirect_to codes_path
  end


  def import 
    Code.import(params[:file])
    redirect_to codes_path, notice: "Codes added successfully"
  end


  private

  def code_params
      params.require(:code).permit(:code, :property, :reference, :post_as, :arrival_date, :status, :booking_type, :booked_date, :booking_user_email, :number_of_tickets, :user_group, :date_claimed, :date_sent)      
  end

end