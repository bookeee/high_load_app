Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:create]
      get "/posts/:posts_amount" => "posts#top"
      post "/evaluations" => "evaluations#do"
      resources :matches, only: [:index]
    end
  end

end
