Rails.application.routes.draw do
  resources :lists, shallow: true do
    resources :todos
  end
  root to: redirect('/lists')
end
