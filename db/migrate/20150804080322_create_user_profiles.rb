class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user
      t.string :first_name, null: false
      t.string :last_name,  null: false

      t.timestamps null: false
    end
  end
end
