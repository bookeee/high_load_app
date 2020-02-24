Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:create]
      post "/evaluations" => "evaluations#do"
    end
  end

end
