class AddDatas1ToWriters < ActiveRecord::Migration[6.0]
  def change
    add_column :writers, :editor, :boolean, default: false
    add_column :writers, :name, :string, default: ''
  end
end
