class CatsController < ApplicationController
  
  before_action :require_current_user!, only: [:new, :create, :edit, :update]
  before_action :rightful_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.includes(:owner).find(params[:id])
    @ordered_requests = @cat.rental_requests.includes(:requester).order('start_date')
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
    render :edit
  end

  def update
    @cat = current_user.cats.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def rightful_owner
    @cat = Cat.find(params[:id])
    redirect_to cats_url unless @cat.owner == current_user
  end

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end

end
