Rails.application.routes.draw do
  get 'plan_register/index'
  get 'plan_register/show'
  get 'plan_register/create'
  #api
  namespace 'api' do
    namespace 'v1' do
      namespace 'webgui' do
        post '/writer/signup' => 'writer#signup'
        post '/writer/signin' => 'writer#signin'
        get '/writer/home' => 'writer#home'
        get '/article_request/can' => 'article_request#can'

        #admin
        post '/article_request/resubmit' => 'article_request#resubmit'

        resources :plan_register, only: [:index,:show,:create] 
        resources :article_request, only: [:index,:show,:create,:edit] 
        resources :unapproved_article, only: [:index,:create,:edit,:update] 
        resources :article, only: [:index,:show,:create,:edit,:update]
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
