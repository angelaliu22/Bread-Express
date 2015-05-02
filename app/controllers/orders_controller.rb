class OrdersController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping

  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    @customer_pending_orders = Order.for_customer(current_user.customer.id).not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
    @customer_past_orders = Order.for_customer(current_user.customer.id).shipped.chronological.paginate(:page => params[:page]).per_page(5)
    @all_pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
    @all_past_orders = Order.shipped.chronological.paginate(:page => params[:page]).per_page(5)
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
      @all_items = Item.all
      @order_items = @order.order_items.to_a
  end

  def create
    @order = Order.new(order_params)
      
      #variables that the view uses
      @all_items = Item.all
    @cart_order_items = get_list_of_items_in_cart
    @cart_subtotal = calculate_cart_items_cost
    @customer_id = current_user.customer.id

  #convert expiration month and year to integers 
    @order.expiration_year = @order.expiration_year.to_i
    @order.expiration_month = @order.expiration_month.to_i

  #set some params for the payment receipt 
    @order.date = Date.today
    @order.customer_id = current_user.customer.id
      
    if @order.save
        save_each_item_in_cart(@order)
        @order.pay
        clear_cart
        create_cart
    else
        render action: 'checkout_cart'
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
    
    def checkout_cart
        @order = Order.new
        @cart_order_items = get_list_of_items_in_cart
        @cart_subtotal = calculate_cart_items_cost
        @customer_id = current_user.customer.id
    end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
      params.require(:order).permit(:address_id, :credit_card_number, :expiration_year, :expiration_month)
  end







end