Rails.application.routes.draw do
  resources :queries
  resources :namespaces do
    resources :permissions, controller: :namespace_permissions
  end

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
end
