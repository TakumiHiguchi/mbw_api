class AddDatas1ToWriters < ActiveRecord::Migration[6.0]
  def change
    add_column :writers, :editor, :boolean, default: false
  end
end
