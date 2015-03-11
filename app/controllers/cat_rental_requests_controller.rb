class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end

  def create
    @request = CatRentalRequest.new(cat_request_params)
    @cats = Cat.all

    if @request.save
      flash[:success] = "Cat request was successful."
      redirect_to cat_url(@request.cat_id)
    else
      flash.now[:error] = "Bad request parameters."
      render :new
    end
  end

  private

  def cat_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
