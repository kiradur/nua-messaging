Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages, except: :new
  get 'messages/:id/reply', to: 'messages#new', as: :new_message
  post 'messages/:id/lost_prescription', to: 'messages#lost_prescription', as: :lost_prescription

end
