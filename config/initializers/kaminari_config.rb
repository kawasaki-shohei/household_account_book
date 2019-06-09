# frozen_string_literal: true
Kaminari.configure do |config|
  config.default_per_page = 10
  # config.max_per_page = nil
  config.window = 0  # 今いるページから左右に何ページ分表示するか 1 2 (3) 4 5
  # config.outer_window = 0
  # config.left = 1  # 最初のページから何ページ分表示するか
  # config.right = 1  # 最後のページから何ページ分表示するか
  # config.page_method_name = :page
  # config.param_name = :page
  # config.params_on_first_page = false
end
