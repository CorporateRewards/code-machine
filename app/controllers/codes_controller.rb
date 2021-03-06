class CodesController < ApplicationController
  layout 'code_submission', only: :user_codes
  def code
    @code ||= Code.find(params[:id])
  end

  helper_method :code
  def index
    @codes = Code.where.not(user_registered_at: [nil, ""]).order(id: :desc).page(params[:page]).per(50)
    @unregistered_codes = Code.where(user_registered_at: [nil, ""]).order(id: :desc).page(params[:page]).per(50)
  end

  def new
    @code = Code.new
  end

  def create
    @code = Code.new(code_params)
    @code.initiate_code
    
    if @code.save
      flash.notice = "Code created!"
      render :show
    else
      flash.now[:error] = "Sorry, there was a problem creating your code"
      render :new
    end
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
    @file = params[:file]
    if Code.validate_file(@file)
      Code.import(@file)
      flash.notice = "Codes added successfully"
      redirect_to codes_path
    else
      flash[:error] = "Sorry, there was a problem importing your codes"
      redirect_to codes_path
    end
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

  def claimed_codes
    @claimed_codes = Code.where.not(date_claimed: [nil, ""]).where(date_sent: [nil, ""])
    respond_to do |format|
      format.html
      format.csv { send_data @claimed_codes.to_csv, filename: "all-unsent-claimed-codes.csv" }
    end
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
                                  :agency_email,
                                  :user_registered_at
                                  )      
  end

end