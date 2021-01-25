class CreateItWayWordUses < ActiveRecord::Migration[5.1]
  def change
    create_table :it_way_word_uses do |t|
      t.integer :word_id
      t.integer :chat_id

      t.timestamps
    end
  end
end
