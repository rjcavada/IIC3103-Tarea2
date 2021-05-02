Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'artists', to: 'artists#index'
  post 'artists', to: 'artists#create'
  get 'artists/:id', to: 'artists#show'
  delete 'artists/:id', to: 'artists#destroy'

  get 'artists/:id/albums', to: 'artists#show_albums'
  get 'artists/:id/tracks', to: 'artists#show_tracks'

  get 'albums', to: 'albums#index'
  get 'albums/:id', to: 'albums#show'
  delete 'albums/:id', to: 'albums#destroy'

  post'artists/:id/albums', to: 'albums#create'
  get 'albums/:id/tracks', to: 'albums#show_tracks'

  get 'tracks', to: 'tracks#index'
  get 'tracks/:id', to: 'tracks#show'
  delete 'tracks/:id', to: 'tracks#destroy'
  
  post 'albums/:id/tracks', to: 'tracks#create'

  put 'artists/:id/albums/play', to: 'artists#play'

  put 'albums/:id/tracks/play', to: 'albums#play'

  put 'tracks/:id/play', to: 'tracks#play'

  match 'artists/:id/albums', to: 'application#method_not_found', via: :all
  match 'artists/:id/tracks', to: 'application#method_not_found', via: :all
  match 'albums/:id/tracks', to: 'application#method_not_found', via: :all
  match 'artists/:id/albums/play', to: 'application#method_not_found', via: :all
  match 'albums/:id/tracks/play', to: 'application#method_not_found', via: :all
  match 'tracks/:id/play', to: 'application#method_not_found', via: :all
  match :albums, to: 'application#method_not_found', via: :all
  match :tracks, to: 'application#method_not_found', via: :all
  match :artists, to: 'application#method_not_found', via: :all

end
