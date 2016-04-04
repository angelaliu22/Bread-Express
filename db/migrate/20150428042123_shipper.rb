class Shipper < ActiveRecord::Migration
   def up
       shipper = User.new
       shipper.username = "shipper_fake"
        shipper.password = "secret"
        shipper.password_confirmation = "secret"
        shipper.role = "shipper"
        shipper.save!
  end

  def down
      shipper = User.find_by_username "shipper_fake"
        User.delete shipper
  end
end
