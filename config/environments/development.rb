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
  Pusher.app_id = '37535'
  Pusher.key    = 'bbc60f0efd2a75339612'
  Pusher.secret = '5f384ffe6ef6551a9b1f'
end
