class CreateArticleCaches < ActiveRecord::Migration[8.0]
  def change
    create_table :article_caches do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
