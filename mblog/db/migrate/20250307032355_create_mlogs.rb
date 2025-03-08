class CreateMlogs < ActiveRecord::Migration[7.2]
  def change
    create_table :mlogs do |t|
      t.string :title

      t.timestamps
    end
  end
end
