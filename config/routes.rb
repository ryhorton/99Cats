Rails.application.routes.draw do
  resources :cats, except: :destroy
  resources :cat_rental_requests, only: [:create, :new] do
    post "approve", on: :member
    post "deny", on: :member
  end

  resource :user, only: [:create, :new, :show]
  resource :session, only: [:create, :destroy, :new]

  root to: redirect("/cats")
end
