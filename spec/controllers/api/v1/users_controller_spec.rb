require 'rails_helper'

describe Api::V1::UsersController, type: :controller do

  let(:user_1) { Fabricate(:user_authenticated) }
  let (:admin_user) { Fabricate(:admin_user).tap { |u| u.remember_me! } }

  describe "#show" do
    it "should be rendered with UserSerializer" do
      get :show, id: user_1.id
      res = jsonfy(response.body)
      expect(response).to be_ok
      expect(res).to eq(UserSerializer.new(user_1).as_json)
    end
  end

  describe "#create" do
    context "successfully creates a User" do
      let(:user_params) { Fabricate.attributes_for(:user) }

      it "should return the created User" do
        post :create, user: user_params, token: admin_user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:email]).to eq(user_params[:email])
        expect(res[:role]).to eq(user_params[:role].to_s)
      end
    end
  end

  describe "#update" do
    let(:user_2) { Fabricate(:user) }
    let(:new_user_params) {{ role: 'guest' }}
    let(:new_user_params_email) {{ email: 'guest@guttenberg.com' }}

    context "User w/ normal role" do
      it "should not be able to update other users" do
        patch :update, id: user_2.id, user: new_user_params, token: user_1.remember_token
        expect(response).to be_unauthorized
      end

      it "should not be able to update his own role" do
        patch :update, id: user_1.id, user: new_user_params, token: user_1.remember_token
        expect(response).to be_ok
        res = jsonfy(response.body)
        expect(res[:email]).to eq(user_1.email)
        expect(res[:role]).to_not eq(new_user_params[:role])
      end

      it "should be able to update his email" do
        patch :update, id: user_1.id, user: new_user_params_email, token: user_1.remember_token
        expect(response).to be_ok
        res = jsonfy(response.body)
        expect(res[:email]).to eq(new_user_params_email[:email])
      end
    end

    context "User w/ admin role" do
      it "should be able to update any user" do
        patch :update, id: user_2.id, user: new_user_params, token: admin_user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:email]).to eq(user_2.email)
        expect(res[:role]).to eq(new_user_params[:role])
      end
    end
  end

  describe "#destroy" do

    context "User w/ normal role" do
      it "should not be able to delete his account" do
        user_id = user_1.id
        delete :destroy, id: user_id, token: user_1.remember_token
        expect(response).to be_unauthorized
      end
    end

    context "User w/ admin role" do
      it "should be able to delete any user" do
        user_id = user_1.id
        delete :destroy, id: user_id, token: admin_user.remember_token
        expect { User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to be_ok
      end
    end
  end

end
