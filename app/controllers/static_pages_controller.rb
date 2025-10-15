class StaticPagesController < ApplicationController
  def profile
    @name = "おかりな"
    @age = "1993/6/15"
    @history =[ "2014年: 大学中退", "2015年〜現在: 子育て期間", "2025年5月〜: RUNTEQにてプログラミング学習中" ]
    @hobby = [ "筋トレ", "神社巡り", "占い" ]
    @motivation = <<~TEXT
      工場でのパートがきっかけで「ものづくり」の楽しさを知り、プログラミングに興味を持ちました。
      子育てが一段落した今、再び自分の可能性に挑戦したいと思い、エンジニアを目指すことにしました。
    TEXT
  end

  def portfolio
  end
end
