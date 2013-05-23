IdeaSite::Application.routes.draw do
  devise_for :users

  resources :events do
    resources :ideas do
      resources :comments, :only => [:create]

      member do
        post '/vote/:vote' => :vote
      end

      collection do
        get '/similar/:title' => :similar
        get '/search' => :search, :as => :search
      end
    end
  end

  controller :pages do
    get '/apis' => :apis, :as => :apis
    get '/schedule' => :schedule, :as => :schedule
    get '/sponsor' => :sponsor, :as => :sponsor
  end

  controller :contact do
    get '/contact' => :new, :as => :contacts
    post '/contact' => :create, :as => :contacts
  end

  controller :newsletter do
    post '/subscribe' => :subscribe, :as => :subscriptions
  end

  root :to => 'events#index'
end
