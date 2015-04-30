class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
      if user.role? :admin
          can :manage, :all
    
      elsif user.role? :baker
          can :index, Item
          
          can :show, User do |u|  
            u.id == user.id
          end
          
          can :index, Order 
          can :show, Order
          
      elsif user.role? :shipper
          can :index, Item
          
          can :show, User do |u|  
            u.id == user.id
          end
          
          can :index, Order 
          can :show, Order
          
      elsif user.role? :customer
          can :show, Customer
          can :edit, Customer
          can :update, Customer
          
          can :show, User do |u|  
            u.id == user.id
          end
          
          can :index, Order
          can :show, Order
          can :create, Order
          can :destroy, Order
          can :add_item, Order
          can :cart, Order
          can :checkout_cart, Order
          
          can :index, Address
          can :create, Address
          can :update, Address
          can :destroy, Address
          
          can :index, Item
          can :show, Item
          
      else
          can :create, Customer
          can :index, Item
          can :show, Item
      end
  end
end
