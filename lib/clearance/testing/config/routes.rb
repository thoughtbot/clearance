clearance_root = File.expand_path('../../../../..', __FILE__)
routes_file = File.join(
  clearance_root,
  'lib',
  'generators',
  'clearance',
  'install',
  'templates',
  'routes.rb'
)

Rails.application.routes.draw do
  root to: "application#show"

  eval File.read(routes_file)
end
