class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
      if user.role? :admin
          can :manage, :all
    
      elsif user.role? :baker
          
      elsif user.role? :shipper
          
      elsif user.role? :customer
          can :show, Customer
          can :edit, Customer
          can :update, Customer
      else
          can :create, Customer
          can :index, Item
      end
  end
end
