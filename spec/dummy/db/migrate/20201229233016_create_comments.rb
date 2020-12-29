class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :subject
      t.text   :body
      t.string :attachment
      t.string :other_attachment

      t.timestamps
    end
  end
end
