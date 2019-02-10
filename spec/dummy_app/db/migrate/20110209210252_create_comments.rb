class CreateComments < ActiveRecord::Migration[5.2]
  def self.up
    create_table :comments do |t|
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
