class ItemPricesController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping
    
    before_action :set_item_price, only: [:show, :edit, :update, :destroy]
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
      authorize! :create, @item_price
      if @item_price.save
      # if saved to database
          redirect_to item_path(@item_price.item)
    else
      # return to the 'new' form
          redirect_to item_path(@item_price.item), error: "#{@item_price.errors.full_messages}"
    end
  end

  def update
      if @item_price.item_price_attributes(item_price_params)
          redirect_to @item_price, notice: "Your item was revised in the system."
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
        params.require(:item_price).permit(:id, :item_id, :price, :start_date, :end_date)  
    end
    
end