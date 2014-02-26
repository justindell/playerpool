require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Playerpool
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false
    config.i18n.enforce_available_locales = false
    config.generators do |g|
      g.template_engine :haml
    end

    Pusher.app_id = '37535'
    Pusher.key    = 'bbc60f0efd2a75339612'
    Pusher.secret = '5f384ffe6ef6551a9b1f'
  end
end
