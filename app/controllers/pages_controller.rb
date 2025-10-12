require 'ostruct'

class PagesController < ApplicationController
  def home
    @articles = [
      OpenStruct.new(title: "サンプル記事1", summary: "これはテスト用の説明文です", url: "#"),
      OpenStruct.new(title: "サンプル記事2", summary: "カードのデザイン確認用です", url: "#"),
      OpenStruct.new(title: "サンプル記事3", summary: "後でAPIとつなぎます", url: "#")
    ]
  end
end
