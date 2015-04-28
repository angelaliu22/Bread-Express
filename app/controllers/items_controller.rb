class ItemsController < ApplicationController
    
    include BreadExpressHelpers::Cart
    include BreadExpressHelpers::Shipping
    
    before_action :set_item, only: [:show, :edit, :update, :destroy, :complete, :incomplete]
  before_action :check_login
  # authorize_resource

  def index
      if logged_in? && !current_user.role?(:customer)
          @all_items = Item.all.paginate(:page => params[:page]).per_page(10)
      else
          @all_items = Item.active.all.paginate(:page => params[:page]).per_page(10)
      end
  end

  def show
      authorize! :show, @item
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
      authorize! :create, @item
      @item.created_by = current_user.id
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
        params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)  
    end
    
end