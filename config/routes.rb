Rails.application.routes.draw do
  root "home#index"

  namespace :auth do
    resources :sessions, only: [:destroy] do
      collection do
        get :google_sing_in
        get :google_callback
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
