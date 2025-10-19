require "ostruct"

class PagesController < ApplicationController
  def index
  @articles = ArticleCache.all.order(published_at: :desc).limit(3)
  end
end
