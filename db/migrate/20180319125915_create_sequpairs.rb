class CreateSequpairs < ActiveRecord::Migration[5.1]
  def change
    create_table :sequpairs do |t|
      t.text :seq1
      t.text :seq2
      t.string :mattype
      t.text :result
      t.string :gap
      t.string :mismatch

      t.timestamps
    end
  end
end
