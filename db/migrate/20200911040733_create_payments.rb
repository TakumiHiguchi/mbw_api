class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :writer_id
      t.integer :unsettled, default: 0
      t.integer :confirm, default: 0
      t.integer :paid, default: 0

      t.timestamps
    end
  end
end
