class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.integer :vote, default: 0

      t.integer :votable_id
      t.string :votable_type

      t.timestamps
    end
    add_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:votable_id, :votable_type, :user_id]
  end
end
