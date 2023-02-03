class ItemsController < ApplicationController
  wrap_parameters format: []
  rescue_from  ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show 
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create 
    user = User.find(params[:user_id])
    new_item = user.create_item(item_params)
    render json: new_item, status: :created
  end

  private 

  def render_not_found(invalid)
    render json: { errors: "User not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
