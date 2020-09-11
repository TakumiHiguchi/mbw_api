Rails.application.routes.draw do
  get 'plan_register/index'
  get 'plan_register/show'
  get 'plan_register/create'
  #api
  namespace 'api' do
    namespace 'v1' do
      namespace 'webgui' do
        post '/writter/signup' => 'writter#signup'
        post '/writter/signin' => 'writter#signin'
        resources :plan_register, only: [:index,:show,:create] 
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
