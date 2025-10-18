Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "pages#index"

  get "profile", to: "static_pages#profile"

  get "portfolio", to: "static_pages#portfolio"

  get "articles", to: "articles#index"

  post "articles/sync", to: "articles#sync"
end
