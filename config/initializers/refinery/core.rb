# encoding: utf-8
Refinery::Core.configure do |config|
  # Register extra javascript for backend
  config.register_javascript "flot"
  config.register_javascript "jquery-minicolors"
  config.register_javascript "jquery-font-selector"

  # Register extra stylesheet for backend (optional options)
  config.register_stylesheet "jquery-minicolors", :media => 'screen'
  config.register_stylesheet "jquery-font-selector", :media => 'screen'
end
