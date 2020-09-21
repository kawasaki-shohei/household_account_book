class Api::V1::CategoriesController < ActionController::API
  def index
    #FIXME: ユーザー認証機能の実装していないため、仮でユーザーを指定している
    user = User.first
    @categories = Category.ones_categories(user)
    render json: @categories.as_json(only: [:id, :name])
  end
end
