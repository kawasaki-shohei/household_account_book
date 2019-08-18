require 'rails_helper'

RSpec.describe "demo", type: :request do
  describe '/demo', type: :request do
    context "POST /demo" do
      it "succeeds creating demo records" do
        post demo_path
        expect(response).to have_http_status("302")
      end
    end

    context "DELETE /demo" do
      before { post demo_path }
      it "succeeds deleting all demo users" do
        delete demo_path
        expect(response).to have_http_status("200")
        expect(response.body).to eq("succeeded")
      end
    end
  end

end