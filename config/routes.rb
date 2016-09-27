Rails.application.routes.draw do
  devise_for :users
  mount API::Base => '/'
  mount ActionCable.server => '/cable'
end
