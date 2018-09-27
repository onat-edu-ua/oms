Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :eduroam do
      get ':login/authorize',
          to: 'authorize#show',
          as: :authorize,
          format: :json,
          constraints: { login: LoginRecord::CONST::LOGIN_REGEXP }

      post 'accounting/:session_id',
           to: 'accounting#create',
           as: :accounting,
           format: :json
    end
  end
end
