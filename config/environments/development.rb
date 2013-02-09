Playerpool::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  config.assets.compress = false
  config.assets.debug = true
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  Pusher.app_id = '37132'
  Pusher.key    = 'd3796788a997f2700609'
  Pusher.secret = '7ebfb24a9526017ec80c'
end
