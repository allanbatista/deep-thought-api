Rails.application.routes.draw do
  root "home#index"

  resources :connections do
    collection do
      get :types
    end
  end

  scope :user, controller: :user do
    get '/', action: :show, as: :user
  end

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
