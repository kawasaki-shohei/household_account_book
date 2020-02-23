# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

Rails.application.config.assets.precompile += %w(
  admin-lte/dist/css/skins/skin-red.min.css
  admin-lte/dist/css/skins/skin-black.min.css
)

# css files
Rails.application.config.assets.precompile += Dir[File.join(Rails.root, 'app', 'assets', 'stylesheets', '*.css')].map { |file| File.basename(file) }

# javascripts files
Rails.application.config.assets.precompile += Dir[File.join(Rails.root, 'app', 'assets', 'javascripts', '*.js')].map { |file| File.basename(file) }
