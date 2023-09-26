Rails.application.routes.draw do
  devise_for :users
  resources :slot_bookings do
    collection do
      get 'allocation_history'
      get 'first_entry'
      get 'my_bookings'
    end
  end
  resources :slot_bookings do
    member do
      put :cancel
    end
  end

  root to: 'slot_bookings#new'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
