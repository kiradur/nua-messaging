Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages, except: :new
  get 'messages/:id/reply', to: 'messages#new', as: :new_message

end
