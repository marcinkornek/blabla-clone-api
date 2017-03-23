# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount GrapeSwaggerRails::Engine => "/swagger"
  devise_for :users
  mount API::Base => "/"
  mount ActionCable.server => "/cable"
end
