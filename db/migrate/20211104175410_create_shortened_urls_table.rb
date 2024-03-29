class CreateShortenedUrlsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :shortened_urls do |t|
      # we can link this to a user for interesting things
      t.integer :owner_id
      t.string :owner_type

      # the real url that we will redirect to
      t.text :url, null: false

      # the unique key
      t.string :unique_key, limit: 10, null: false

      # a category to help categorize shortened urls
      t.string :category

      # how many times the link has been clicked
      t.integer :use_count, null: false, default: 0

      # valid until date for expirable urls
      t.datetime :expires_at

      t.timestamps
    end

    # we will lookup the links in the db by key, urls and owners.
    # also make sure the unique keys are actually unique
    add_index :shortened_urls, :unique_key, unique: true
    add_index :shortened_urls, :url, length: 2083
    add_index :shortened_urls, [:owner_id, :owner_type]
    add_index :shortened_urls, :category
  end
end
