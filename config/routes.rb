Rails.application.routes.draw do
  #api
  namespace 'api' do
    namespace 'v1' do
      namespace 'webgui' do
        namespace 'admin' do
          resources :article, only: [:index,:show,:create,:edit,:update]
        end
        post '/writer/signup' => 'writer#signup'
        post '/writer/signin' => 'writer#signin'
        get '/writer/home' => 'writer#home'
        get '/article_request/can' => 'article_request#can'

        #admin
        post '/article_request/resubmit' => 'article_request#resubmit'

        resources :search, only: [:index] 
        resources :lyrics, only: [:show] 
        resources :plan_register, only: [:index,:show,:create] 
        resources :article_request, only: [:index,:show,:create,:edit] 
        resources :unapproved_article, only: [:index,:create,:edit,:update] 
        resources :article, only: [:index,:show,:create,:edit,:update]
      end
      namespace 'smapr' do
        resources :article, only: [:create]
      end
      namespace 'mbw' do
        resources :search, only: [:index]
        resources :tag, only: [:show]
        resources :article, only: [:index,:show]
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
