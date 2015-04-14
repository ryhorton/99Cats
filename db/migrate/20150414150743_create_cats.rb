class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.datetime :birth_date, presence: true
      t.string :color, presence: true
      t.string :name, presence: true
      t.string :sex, presence: true
      t.text :description

      t.timestamps null: false
    end
  end
end
