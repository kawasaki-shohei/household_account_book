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
  header.css
  toggle_switch.css
  overwrite_admin_lte.css
  overwrite_admin_lte_for_admin.css
  home.css
  login.css
  admin_login.css
  analyses.css
  expenses.css
  repeat_expenses.css
  notifications.css
)

Rails.application.config.assets.precompile += %w(
  analyses_index.js
  adminlte_sortable_plugin.js
  both_expenses_form.js
  expenses_input_amount.js
  expenses_index.js page_top.js
)
