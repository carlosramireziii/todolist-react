Rails.application.routes.draw do
  resources :lists
  root to: redirect('/lists')
end
