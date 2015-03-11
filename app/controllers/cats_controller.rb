class CatsController < ApplicationController
  before_action :redirect_unless_cat_owner!, only: [:update, :edit]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = 'Bad cat parameters'
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:error] = 'Bad cat parameters'
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :gender, :color, :description)
  end
end
