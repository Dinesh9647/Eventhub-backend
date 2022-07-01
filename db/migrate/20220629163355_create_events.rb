class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description, default: ""
      t.datetime :reg_start
      t.datetime :reg_end
      t.float :fees, default: 0
      t.string :venue, default: "Online"
      t.integer :category
      t.text :url

      t.timestamps
    end
  end
end
