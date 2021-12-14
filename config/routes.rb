Rails.application.routes.draw do
  root to: 'questions#index'
  
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: :index
  end
end
