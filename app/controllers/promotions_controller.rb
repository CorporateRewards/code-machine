class PromotionsController < ApplicationController


  def promotion
    @promotion ||= Promotion.find(params[:id])
  end

  helper_method :promotion

  def index
    @promotions = Promotion.all
  end

  def show
    promotion
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promo_params)
    if @promotion.save
      flash.notice = "Saved"
      redirect_to :index
    else
      flash.notice = "Oh no, something went wrong"
      render :new
    end
  end

  def edit

  end

  def update

  end 

  def destroy

  end

private

  def promo_params
    params.require(:promotion).permit(:name, :valid_from, :valid_to, :promotion_detail, :property)
  end
end
