Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get 'evosubmatrice/index'

  get 'evosubmatrice/show'

  resources :sequpairs
  get 'welcome/index'

  get 'welcome/tester'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
