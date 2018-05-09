Rails.application.routes.draw do
  resources :heroku_applications, only: %i[] do
    resources :restarts, only: %i[create]
  end
end
