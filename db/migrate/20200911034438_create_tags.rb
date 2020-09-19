class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :key
      t.string :thumbnail
      t.string :description

      t.timestamps
    end
  end
end
