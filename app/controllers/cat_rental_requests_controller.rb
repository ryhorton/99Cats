class CatRentalRequestsController < ApplicationController

  def index
    @cat_rental_requests = CatRentalRequest.all

    render :index
  end

  def new
    @cat_rental_request = CatRentalRequest.new

    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @cat_rental_request.save
      redirect_to cat_rental_request_url(@cat_rental_request)
    else
      render :new
    end
  end

  def show
    @cat_rental_request = CatRentalRequest.find(params[:id])

    render :show
  end

  def order

  end

  
  private
  def cat_rental_request_params
    params[:cat_rental_request].permit(:cat_id, :start_date, :end_date)
  end
end
