require 'rails_helper'

describe Api::V1::AuthorsController, type: :controller do

  let(:user) { Fabricate(:user_authenticated) }
  let(:secondary_user) { Fabricate(:user_authenticated) }

  describe "#index" do
    let!(:user_authors) { 10.times.map { Fabricate(:author, user: user) } }
    let!(:secondary_user_authors) { 5.times.map { Fabricate(:author, user: secondary_user) } }

    context "scoped by User" do
      it "should return only Authors owned by scoped User" do
        get :index, user_id: user.id
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(user_authors.size)
        expect(res.map { |a| a[:id] }).to eq(user_authors.map(&:id))

        get :index, user_id: secondary_user.id
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(secondary_user_authors.size)
        expect(res.map { |a| a[:id] }).to eq(secondary_user_authors.map(&:id))
      end
    end

    context "unscoped" do
      it "should return all Authors" do
        get :index
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(user_authors.size+secondary_user_authors.size)
      end
    end
  end

  describe "#show" do
    let(:author) { Fabricate(:author) }
    it "should be rendered with AuthorSerializer" do
      get :show, id: author.id
      res = jsonfy(response.body)
      expect(response).to be_ok
      expect(res).to eq(AuthorSerializer.new(author).as_json)
    end
  end

  describe "#create" do
    context "successfully creates an Author" do
      let(:author_params) { Fabricate.attributes_for(:author) }

      it "should return the created Author" do
        post :create, author: author_params, token: user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:name]).to eq(author_params[:name])
        expect(res[:nationality]).to eq(author_params[:nationality])
        expect(res[:user_id]).to eq(user.id)
      end
    end
  end

  describe "#update" do
    let(:author) { Fabricate(:author, user: user) }
    let(:new_author_params) { { nationality: "french", name: 'Albert Camus' } }

    context "User w/ normal role" do
      it "should be able to update his Authors successfully" do
        patch :update, id: author.id, author: new_author_params, token: user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:id]).to eq(author.id)
        expect(res[:name]).to eq(new_author_params[:name])
        expect(res[:nationality]).to eq(new_author_params[:nationality])
        expect(res[:user_id]).to eq(user.id)
      end

      it "should not be able to update Authors from other Users" do
        patch :update, id: author.id, author: new_author_params, token: secondary_user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_unauthorized
        expect(res[:errors].first).to include('Not allowed to perform this action')
      end

      it "should not be able to update an Author with invalid params" do
        patch :update, id: author.id, author: { name: nil }, token: user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_unprocessable
        expect(res[:errors].first).to include("can't be blank")
      end
    end

    context "User w/ admin role" do
      let (:admin_user) { Fabricate(:admin_user).tap { |u| u.remember_me! } }

      it "should be able to update any Author" do
        patch :update, id: author.id, author: new_author_params, token: admin_user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:id]).to eq(author.id)
        expect(res[:name]).to eq(new_author_params[:name])
        expect(res[:nationality]).to eq(new_author_params[:nationality])
        expect(res[:user_id]).to eq(user.id)
      end
    end
  end

  describe "#destroy" do

    let(:author) { Fabricate(:author, user: user) }

    context "User w/ normal role" do
      it "should be able a User to delete his Authors" do
        author_id = author.id
        delete :destroy, id: author_id, token: user.remember_token
        expect { Author.find(author_id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to be_ok
      end

      it "should not be able to delete Authors from other Users" do
        delete :destroy, id: author.id, token: secondary_user.remember_token
        res = jsonfy(response.body)
        expect(res[:errors].first).to include('Not allowed to perform this action')
        expect(response).to be_unauthorized
      end
    end

    context "User w/ admin role" do
      let (:admin_user) { Fabricate(:admin_user).tap { |u| u.remember_me! } }

      it "should be able to delete any Author" do
        author_id = author.id
        delete :destroy, id: author_id, token: admin_user.remember_token
        expect { Author.find(author_id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to be_ok
      end
    end
  end

end
