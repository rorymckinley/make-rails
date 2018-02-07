class CreateInteractions < ActiveRecord::Migration[5.1]
  def change
    create_table :interactions do |t|
      t.string :sender_id
      t.string :make
      t.string :model
      t.timestamps
    end
  end
end
