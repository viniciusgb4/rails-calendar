Rails.application.routes.draw do

  devise_for :users

  root 'calendars#index'

  get 'today', to: 'calendars#today'
  get 'previous_page', to: 'calendars#previous_page'
  get 'next_page', to: 'calendars#next_page'

  resources :reminders, except: [:show]

end
