class CodesController < ApplicationController

  def code
    @code ||= Code.find(params[:id])
  end

  helper_method :code
  def index
    @codes = Code.order(id: :desc).page(params[:page]).per(10)
  end

  def new
    @code = Code.new
  end

  def create
    create_code = Code.new_code(code_params)
    redirect_to codes_path, notice: "Code added successfully"
  end

  def edit
    code
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
    code
  end

  def user_codes

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

  def approval
    @codes = Code.where.not(approval_required_at: [nil, ""]).where(approved_at: [nil, ""]).page(params[:page]).per(10)
  end

  def approve
    code.approve_code
    redirect_to code, notice: 'Code was successfully approved.'
  end

  def process_code
    code.process_code
    redirect_to code, notice: 'Code was successfully marked as sent.'
  end

  def export_all_codes
    @all_codes = Code.all
    respond_to do |format|
      format.html
      format.csv { send_data @all_codes.to_csv, filename: "all-codes.csv" }
    end
  end

  def update_codes
    Code.update(params[:file])
    redirect_to codes_path, notice: "Codes updated successfully"
  end
  private

  def code_params
      params.require(:code).permit(
                                  :id, 
                                  :code, 
                                  :property, 
                                  :reference, 
                                  :post_as, 
                                  :arrival_date, 
                                  :status, 
                                  :booking_type, 
                                  :booked_date, 
                                  :booking_user_email, 
                                  :number_of_tickets, 
                                  :user_group, 
                                  :date_claimed, 
                                  :date_sent, 
                                  :booking_email, 
                                  :agency_email
                                  )      
  end

end