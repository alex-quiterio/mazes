require_dependency 'api_constraint'

Rails.application.routes.draw do
  api_v1 = ApiConstraint.new('myst', version: '1', default: true, format: :json)
  namespace :api do
    scope module: api_v1.module, constraints: api_v1 do
      resources :authors do
        resources :books
      end
      resources :books
      resources :users, except: :index do
        resources :authors
        resources :books
      end
      devise_for :users, controllers: { sessions: "api/#{api_v1.module}/sessions" }, skip: [:passwords, :registrations]
    end
  end
end
