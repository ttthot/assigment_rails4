class CreateMlogs < ActiveRecord::Migration[7.2]
  def change
    create_table :mlogs do |t|
      t.string :title
      t.string :description
      t.text :content
      t.string :tags

      t.timestamps
    end
  end
end
