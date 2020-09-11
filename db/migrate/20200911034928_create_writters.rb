class CreateWritters < ActiveRecord::Migration[6.0]
  def change
    create_table :writters do |t|
      t.string :email
      t.string :password
      t.string :session
      t.integer :maxAge

      t.timestamps
    end
  end
end
