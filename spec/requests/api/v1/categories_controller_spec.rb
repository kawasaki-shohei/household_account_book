require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :request do

  describe "GET /categories", type: :request do
    let!(:user) { create(:user_with_partner) }
    let!(:category) { create(:own_category, user: user) }
    it "succeeded getting categories" do
      headers = { "Accept": "application/json" }
      get api_v1_categories_path, :headers => headers
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)[0]["name"]).to eq(category.name)
    end
  end

end
