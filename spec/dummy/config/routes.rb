Rails.application.routes.draw do
  root to: "application#show"
  get "/static-endpoint", to: "application#static_endpoint", as: :static_endpoint
end
