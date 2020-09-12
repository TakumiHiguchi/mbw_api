class CreatePlanRegisters < ActiveRecord::Migration[6.0]
  def change
    create_table :plan_registers do |t|
      t.string :email
      t.string :key
      t.integer :maxage
      t.string :name
      t.string :session

      t.timestamps
    end
  end
end
