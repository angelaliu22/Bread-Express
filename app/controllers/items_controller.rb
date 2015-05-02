class ItemsController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping
    
    before_action :set_item, only: [:show, :edit, :update, :destroy]
#  before_action :check_login
  # authorize_resource

  def index
      if !logged_in?
           @active_items = Item.active.paginate(:page => params[:page]).per_page(10)
          
      elsif logged_in? && current_user.role?(:admin)
          @active_items = Item.active.paginate(:page => params[:page]).per_page(10)
          @inactive_items = Item.inactive.paginate(:page => params[:page]).per_page(10)
          @price_history = ItemPrice.for_item(params[:id]).paginate(:page => params[:page]).per_page(10)
          
      elsif logged_in? && current_user.role?(:customer)
          @active_items = Item.active.paginate(:page => params[:page]).per_page(10)
          @related_items = Item.for_category(params[:category]).paginate(:page => params[:page]).per_page(10)
          
      elsif logged_in? && current_user.role?(:baker)
        @active_items = Item.active.paginate(:page => params[:page]).per_page(10)
          @unshipped_items = OrderItem.unshipped.paginate(:page => params[:page]).per_page(10)
          
        elsif logged_in? && current_user.role?(:shipper)
            @active_items = Item.active.paginate(:page => params[:page]).per_page(10)
            
      else
    
      end
  end

  def show
      authorize! :show, @item
      @item_price_history = ItemPrice.for_item(@item.id).chronological.paginate(:page => params[:page]).per_page(10)
  end

  def new
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
      redirect_to @item
  end
  

  private

    def set_item
        @item = Item.find(params[:id])
    end

    def item_params
        params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active, item_price_attributes: [:id, :price, :start_date, :end_date, :_destroy])  
    end
    
end