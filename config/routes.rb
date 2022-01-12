Rails.application.routes.draw do
  root to: 'questions#index'
  
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: :index do
      member do
        patch :best
      end
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
end
