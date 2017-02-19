Rails.application.routes.draw do
  resource :messages do
    collection do
      post 'reply'
    end
  end

  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :users, except: [:index]

  resources :phone_numbers

  resources :uploads, only: [:index, :create, :destroy]

  resources :pdfs, only: [:index, :show, :create, :destroy]

  resources :folders do
    resources :notes
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get '/notes', to: 'notes#user_notes'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
