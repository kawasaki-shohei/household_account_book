require 'rails_helper'

RSpec.describe Api::V1::ExpensesController, type: :request do

  describe "POST /create", type: :request do
    let!(:user) {create(:user_with_partner)}
    let!(:category) {create(:own_category, user: user)}
    let!(:headers) { {"Accept": "application/json"} }
    it "succeeded saving expense" do
      post api_v1_expenses_path,
           params: {
             amount: 1000,
             category_id: category.id,
             date: Date.current.yesterday,
             memo: "memo"
           },
           :headers => headers
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["succeeded"]).to be_truthy
      expect(JSON.parse(response.body)["message"]).to eq("出費を保存しました。#{category.name}: 1,000円")
    end

    it "failed saving expense" do
      post api_v1_expenses_path,
           params: {
             amount: nil,
             category_id: category.id,
             date: nil,
             memo: "memo"
           },
           :headers => headers
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["succeeded"]).to be_falsey
      expect(JSON.parse(response.body)["message"]).to eq("支払い金額を入力してください。¥nDateを入力してください。")
    end
  end

end
