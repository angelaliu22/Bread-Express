class Customer < ActiveRecord::Migration
  def up
      customer = User.new
      customer.username = "customer_fake"
        customer.password = "secret"
        customer.password_confirmation = "secret"
        customer.role = "customer"
        customer.save!
  end

  def down
      customer = User.find_by_username "customer_fake"
        User.delete customer
  end
end
