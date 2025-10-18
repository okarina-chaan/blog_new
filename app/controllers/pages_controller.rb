require "ostruct"

class PagesController < ApplicationController
  def index
    @articles = ArticleCache.all.order(created_at: :desc)
  end
end
