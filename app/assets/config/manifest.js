Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.paths << Rails.root.join('node_modules')
