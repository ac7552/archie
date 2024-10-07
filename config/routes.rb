Rails.application.routes.draw do
  get 'cards/new', to: 'cards#new'
  get 'onboarding/index', to: 'onboarding#index'
  post 'cards/add_card', to: 'cards#add_card'

  devise_for :users, 
    path: '', 
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }
  resources :invitations
  post "/fetch_clients" => "invitations#fetch_clients"
  post "/projects/user_projects" => "projects#user_projects"

  resources :projects do
    resources :milestones, only: [] do
      resources :payments, only: [:new, :create] do
        collection do 
          post 'create_payment_intent'
          post 'release_funds'
          post 'create_customer'
          post 'create_account_link'
        end
      end
    end
    resources :questionnaires, only: [:create, :index] do
      resources :questions, only: [:create, :index]
    end
    
    resources :contracts, only: [:create, :index] do
      member do
        put 'agree'
        put 'client_sign'
        put 'contractor_sign'
        post 'update_section'
        post 'send_for_signing'
      end
    end
  end
  post 'docusign/create_template', to: 'docusign#create_template'
  post 'docusign/send_envelope', to: 'docusign#send_envelope'
  get 'docusign/check_envelope_status/:envelope_id', to: 'docusign#check_envelope_status'


  post 'contracts/webhook', to: 'contracts#webhook'
  resources :users
  post '/users/add_card', to: 'users#add_card'
  post '/users/add_debit_card', to: 'users#add_debit_card'
  post '/webhooks/stripe', to: 'webhooks#stripe'
  resources :questionnaires, only: [:show, :update, :destroy] do
    resources :questions, only: [:show, :update, :destroy]
  end

  resources :questions, only: [:show, :update, :destroy]

  resources :contracts, only: [:show, :update, :destroy]

end
