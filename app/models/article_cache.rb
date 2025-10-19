class ArticleCache < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true, uniqueness: true

  def self.sync_from_hatena(limit: 10)
      service = HatenaBlogService.new
      articles = service.fetch_articles(limit: limit)

      ArticleCache.delete_all

      articles.each do |article|
        ArticleCache.create!(
          title: article[:title],
          url: article[:url],
          published_at: Time.parse(article[:published_at])
        )
      end
  rescue => e
    Rails.logger.error("ArticleCache Sync Error: #{e.message}")
  end
end
