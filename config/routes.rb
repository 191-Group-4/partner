Rails.application.routes.draw do
  get 'users/profile'
  get 'help/index'

  root :to => "visitors#index"
#  devise_for :users
devise_for :users, :controllers => { registrations: 'registrations' }


  resources :users do
    member do
        get :flop
        get :cancel
        get :clearall
        get :export
        get :registrations
        get :clearpartnership
        get :confirm
    end
    end

devise_scope :user do
  get "sign_in", to: "devise/sessions#new"
  get "sign_up", to: "devise/registrations#new"
end


end
