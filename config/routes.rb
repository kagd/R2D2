Rails.application.routes.draw do

  scope path: 'api', defaults: { format: :json } do
    match '*path' => 'base#cors', via: :options

    get 'github', to: 'github#index'
    get 'diablo', to: 'diablo#index'
  end
end
