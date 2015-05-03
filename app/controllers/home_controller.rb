class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
      @num_items_to_bake = OrderItem.unshipped.length
      @items_to_bake = OrderItem.unshipped.paginate(:page => params[:page]).per_page(10)   
      
      @num_unshipped_orders = Order.not_shipped
      @unshipped_orders = Order.not_shipped.paginate(:page => params[:page]).per_page(10) 
  end
    
    def items_to_bake
        @items_to_bake = OrderItem.unshipped.paginate(:page => params[:page]).per_page(10)   
    end 
    
    def orders_to_ship 
        @unshipped_orders = Order.not_shipped.paginate(:page => params[:page]).per_page(10) 
    end
    
    def order_has_been_shipped
        @order_items = OrderItem.find_all_by_order_id(params[:id])
        @order_items.each do |oi|
            oi.shipped_on = Date.today
            oi.save!
        end
        redirect_to home_path, notice: "Order #{params[:id]} has been shipped!"
    end
    
  def about
  end

  def privacy
  end

  def contact
  end






end