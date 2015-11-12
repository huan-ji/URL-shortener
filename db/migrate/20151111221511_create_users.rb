class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email
      t.timestamps
    end

    add_index(:users, :email, unique: true)


  end
end
