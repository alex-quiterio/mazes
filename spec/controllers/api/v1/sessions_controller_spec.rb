require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do

  let(:user) { Fabricate(:user) }
  let(:valid_credentials) {{ email: user.email, password: user.password }}
  let(:invalid_credentials) {{ email: user.email, password: "#{user.password}_invalid" }}

  describe "#create" do
    it "should return the authenticated user with the new token and the ttl information" do
      date = Time.zone.now
      expected_session_ttl_end = date + 2.hours
      Timecop.freeze(date) do
        post :create, valid_credentials
      end
      res = jsonfy(response.body)
      expect(response).to be_ok
      expect(res[:token]).to eql(user.reload.remember_token)
      expect(res[:ttl]).to eql(expected_session_ttl_end.to_s)
    end

    it "returns a json with an error" do
      post :create, invalid_credentials
      reply = JSON.parse(response.body, symbolize_names: true)
      expect(reply[:errors].first).to eql("invalid email or password")
      expect(response).to be_unprocessable
    end
  end

  describe "#destroy" do
    let(:authenticated_user) { Fabricate(:user_authenticated) }

    it "should return :ok when the session actualy exists" do
      delete :destroy, token: authenticated_user.remember_token
      expect(response).to be_ok
    end

    it "should return :unprocessable_entity when the session does not exist" do
      delete :destroy, token: user.remember_token
      expect(response).to be_unprocessable
    end
  end
end
