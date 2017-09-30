Rails.application.configure do
  config.cache_classes = false
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.eager_load = false
  config.consider_all_requests_local = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
