Rails.application.routes.draw do
  resources :pdfs
  resources :document_pages
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :users, except: [:index]
  resources :uploads, only: [:index, :create, :destroy, :show]

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
