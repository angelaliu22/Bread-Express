class Baker < ActiveRecord::Migration
  def up
      baker = User.new
      baker.username = "baker_fake"
        baker.password = "secret"
        baker.password_confirmation = "secret"
        baker.role = "baker"
        baker.save!
  end

  def down
      baker = User.find_by_username "baker_fake"
        User.delete baker
  end
end
