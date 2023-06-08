module Sprockets::Jets
  class Engine < ::Jets::Engine
    config.assets = ActiveSupport::OrderedOptions.new
    config.assets.paths = %w[
      app/assets/config
      app/assets/images
      app/assets/javascripts
      app/assets/stylesheets
    ]
    config.assets.prefix = "/assets"
    config.assets.use_precompiled = false # for development false, for production true, but Jets will serve directly with s3 anyway
    config.assets.precompile      = []
    # See: https://github.com/rails/sprockets/blob/main/UPGRADING.md#manifestjs
    # In Sprockets 4, the manifest file using the manifest.js is encouraged
    # And using individual files like ["application.js", "application.css"] is discouraged.

    # Old jets settings. S3 serving of assets. Still need the configs.
    config.assets.base_url = nil # IE: https://cloudfront.com/my/base/path
    config.assets.cache_control = nil # IE: public, max-age=3600 , max_age is a shorter way to set cache_control.
    config.assets.folders = %w[assets images packs files]
    config.assets.max_age = 3600
    config.assets.webpacker_asset_host = "s3_endpoint"  # true = use conventional by default

    initializer "sprockets-jets-helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        include Helper
      end
    end

    initializer "sprockets-jets-mount-assets" do |app|
      app.routes.prepend do
        # Important: Env.build within block so it's lazy loaded. Otherwise, it
        # may not use the correct config.assets.paths
        sprockets_env = Env.build # Sprockets::Environment.new with config.assets.paths
        mount sprockets_env => Jets.config.assets.prefix, internal: true # /assets
      end
    end

    rake_tasks do
      RakeTasks.load_tasks
    end
  end
end
