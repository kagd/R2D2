class CreateD3ItemAttributes < ActiveRecord::Migration
  def change
    create_table :d3_item_attributes do |t|
      t.integer :d3_item_id
      t.string :type
      t.string :text
      t.string :affix_type
      t.string :color

      t.timestamps
    end
  end
end
