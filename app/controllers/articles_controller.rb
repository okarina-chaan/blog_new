class ArticlesController < ApplicationController
  def index
    @articles = Rails.cache.fetch('hatena_articles', expires_in: 1.hours) do
      ArticleCache.all.order(published_at: :desc)
    end
  end

def sync
  ArticleCache.sync_from_hatena
  
  Rails.cache.delete('articles')
  
  @articles = ArticleCache.all.order(published_at: :desc)

  redirect_to articles_path, notice: '記事を同期しました'
rescue => e
  redirect_to articles_path, alert: "記事の更新に失敗しました: #{e.message}"
end
end
