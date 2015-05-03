class ItemsController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping
    
    before_action :set_item, only: [:show, :edit, :update, :destroy]
#  before_action :check_login
  # authorize_resource

  def index
      @bread_items = Item.active.for_category("bread").paginate(:page => params[:page]).per_page(10)
      @muffin_items = Item.active.for_category("muffins").paginate(:page => params[:page]).per_page(10)
      @pastry_items = Item.active.for_category("pastries").paginate(:page => params[:page]).per_page(10)
  end

  def show
      authorize! :show, @item
      @item_price_history = ItemPrice.for_item(@item.id).chronological.paginate(:page => params[:page]).per_page(10)
  end

  def new
      @item = Item.new
      authorize! :new, @item
  end

  def edit
      authorize! :edit, @item
  end

  def create
      @item = Item.new(item_params)
#      params[:item][:item_price_attributes][:start_date] = Date.today
      authorize! :create, @item
      if @item.save
      # if saved to database
          flash[:notice] = "#{@item.name} has been created."
          redirect_to @item # go to show task page
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
      authorize! :destroy, @item
      @item.destroy
      flash[:notice] = "Successfully removed #{@item.name} from Bread Express."
      redirect_to items_path
  end
  

  private

    def set_item
        @item = Item.find(params[:id])
    end

    def item_params
        params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active, item_price_attributes: [:id, :price, :start_date, :end_date, :_destroy])  
    end
    
end