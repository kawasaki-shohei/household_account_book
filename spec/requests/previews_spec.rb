require 'rails_helper'

RSpec.describe "Previews", type: :request do
  describe '/preview', type: :request do
    context "POST /previews" do
      it "succeeds creating preview records" do
        post preview_path
        expect(response).to have_http_status("302")
      end
    end

    context "DELETE /previews" do
      before { post preview_path }
      it "succeeds deleting all preview users" do
        delete preview_path
        expect(response).to have_http_status("200")
        expect(response.body).to eq("succeeded")
      end
    end
  end

end