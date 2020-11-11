Rails.application.routes.draw do
  #api
  namespace 'api' do
    namespace 'v1' do
      namespace 'webgui' do
        namespace 'admin' do
          post '/article_request/resubmit' => 'article_request#resubmit'

          resources :article, only: [:index,:show,:create,:edit,:update]
          resources :plan_register, only: [:index,:create]
          resources :article_request, only: [:index, :edit, :create]
          resources :instagram, only: [:create]
        end
        namespace 'editor' do
          post '/article_request/resubmit' => 'article_request#resubmit'
          resources :article_request, only: [:index,:edit]
          resources :article, only: [:create]
        end
        post '/writer/signup' => 'writer#signup'
        post '/writer/signin' => 'writer#signin'
        get '/writer/home' => 'writer#home'
        get '/article_request/can' => 'article_request#can'

        resources :search, only: [:index] 
        resources :plan_register, only: [:show] 
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
        resources :lyrics, only: [:show] 
        resources :instagram, only: [:index, :show] 

        # 旧式サイトから301リダイレクトするためのルーティング。後々消す
        get 'our_article' => 'ord_url_redirect#article'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
