class MrUsersController < ApplicationController
  before_action :set_mr_user, only: [:show, :edit, :update, :destroy]

  # GET /mr_users
  # GET /mr_users.json
  def index
    @mr_users = MrUser.all
  end

  # GET /mr_users/1
  # GET /mr_users/1.json
  def show
  end

  # GET /mr_users/new
  def new
    @mr_user = MrUser.new
  end

  # GET /mr_users/1/edit
  def edit
  end

  # POST /mr_users
  # POST /mr_users.json
  def create
    @mr_user = MrUser.new(mr_user_params)

    respond_to do |format|
      if @mr_user.save
        format.html { redirect_to @mr_user, notice: 'Mr user was successfully created.' }
        format.json { render :show, status: :created, location: @mr_user }
      else
        format.html { render :new }
        format.json { render json: @mr_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mr_users/1
  # PATCH/PUT /mr_users/1.json
  def update
    respond_to do |format|
      if @mr_user.update(mr_user_params)
        format.html { redirect_to @mr_user, notice: 'Mr user was successfully updated.' }
        format.json { render :show, status: :ok, location: @mr_user }
      else
        format.html { render :edit }
        format.json { render json: @mr_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mr_users/1
  # DELETE /mr_users/1.json
  def destroy
    @mr_user.destroy
    respond_to do |format|
      format.html { redirect_to mr_users_url, notice: 'Mr user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mr_user
      @mr_user = MrUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mr_user_params
      params.fetch(:mr_user, {})
    end
end
