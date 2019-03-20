class AddUserIdToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_reference :photos, :user
  end
end
