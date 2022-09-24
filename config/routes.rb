Rails.application.routes.draw do
  root "posts#index"
  resources :posts, only: [:new, :create, :show, :edit, :update] do
    collection do
      get 'search'
    end
  end
end
