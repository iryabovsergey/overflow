class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      #-------------------------
      t.string :name
      t.string :password
      t.string :remember_digest   # for remember me option
      t.string :email_check_key
      #-------------------------
      t.timestamps
    end
  end
end
