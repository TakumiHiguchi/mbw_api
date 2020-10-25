class AddDatasToWriters < ActiveRecord::Migration[6.0]
  def change
    add_column :writers, :admin, :boolean, default: false
  end
end
