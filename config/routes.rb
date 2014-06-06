Rails.application.routes.draw do

  root :to => "visitors#index"
  devise_for :users


  resources :users do
    member do
        get :flop
        get :cancel
        get :clearall
        get :export
        get :clearpartnership
    end
    end


  resources :contacts do
    member do
        get :new
        get :create
        get :bug
    end
    end

get '/bug', to: 'contacts#bug'
get '/contacts/new', to: 'contacts#new'

devise_scope :user do
  get "sign_in", to: "devise/sessions#new"
  get "sign_up", to: "devise/registrations#new"
end


end
