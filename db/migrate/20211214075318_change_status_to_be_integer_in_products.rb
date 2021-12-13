class ChangeStatusToBeIntegerInProducts < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :status, :integer
  end
end
