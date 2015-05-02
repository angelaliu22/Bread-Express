class ItemPricessController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping
    
    before_action :set_item_price, only: [:show, :update, :destroy]
#  before_action :check_login
  # authorize_resource

  def index
    
  end

  def show
    
  end

  def new
      @item_price = ItemPrice.new
      authorize! :new, @item_price      
  end

  def edit
  end

  def create
      @item_price = ItemPrice.new(item_price_params)
#      params[:item][:item_price_attributes][:start_date] = Date.today
      authorize! :create, @item_price
      if @item_price.save
      # if saved to database
          flash[:notice] = "#{@item.name} has been created."
          redirect_to @item 
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
      if @item.update(item_params)
          redirect_to @item, notice: "Your item was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    
  end

  private

    def set_item_price
        @item_price = ItemPrice.find(params[:id])
    end

    def item_price_params
        params.require(:item).permit(:id, :price, :start_date, :end_date)  
    end
    
end