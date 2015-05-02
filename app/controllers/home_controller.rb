class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
      @items_to_bake = OrderItem.unshipped.paginate(:page => params[:page]).per_page(10)   
      @unshipped_orders = Order.not_shipped.paginate(:page => params[:page]).per_page(10) 
  end
    
  def about
  end

  def privacy
  end

  def contact
  end






end