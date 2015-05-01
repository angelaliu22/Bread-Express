class OrdersController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping

  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
      @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
        
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end
    
    def add_item
        add_item_to_cart(params[:id])
        
        flash[:notice] = "Item has been added to your cart!"
        @related_items = Item.for_category(Item.find_by_id(params[:id]).category).paginate(:page => params[:page]).per_page(10)
    end
    
    def remove_item
        remove_item_from_cart(params[:id])
        redirect_to view_cart_url, notice: "Item has been removed from your cart!"
    end
    
    def view_cart
        @cart_order_items = get_list_of_items_in_cart
        @cart_subtotal = calculate_cart_items_cost
    end
    
    def place_order
        @order.pay
        clear_cart
        create_cart
        flash[:notice] = "Awesome! Your order has been placed!"
    end
    
#    def view_related_items
#        @related_items = Item.for_category(params[:category]).paginate(:page => params[:page]).per_page(10)
#        redirect_to add_item_path
#    end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id)
  end







end