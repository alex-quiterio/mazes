require 'rails_helper'

describe Api::V1::BooksController, type: :controller do

  let(:user_1) { Fabricate(:user_authenticated) }
  let(:user_2) { Fabricate(:user_authenticated) }

  describe "#index" do
    let!(:author_1) { Fabricate(:author) }
    let!(:author_2) { Fabricate(:author) }
    let!(:user_1_books) { 10.times.map { Fabricate(:book, user: user_1, author: author_1) } }
    let!(:user_2_books) { 5.times.map { Fabricate(:book, user: user_2, author: author_2) } }

    context "scoped by User" do
      it "should return only Books owned by scoped the User" do
        get :index, user_id: user_1.id
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(user_1_books.size)
        expect(res.map { |a| a[:id] }).to eq(user_1_books.map(&:id))

        get :index, user_id: user_2.id
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(user_2_books.size)
        expect(res.map { |a| a[:id] }).to eq(user_2_books.map(&:id))
      end
    end

    context "scoped by Author" do

      let(:author_1_books) { user_1_books }
      let(:author_2_books) { user_2_books }

      it "should return only Books owned by scoped the Author" do
        get :index, author_id: author_1.id
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(author_1_books.size)
        expect(res.map { |a| a[:id] }).to eq(author_1_books.map(&:id))

        get :index, author_id: author_2.id
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(author_2_books.size)
        expect(res.map { |a| a[:id] }).to eq(author_2_books.map(&:id))
      end
    end

    context "unscoped" do
      it "should return all Books" do
        get :index
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res.size).to eq(user_1_books.size+user_2_books.size)
      end
    end
  end

  describe "#show" do
    let(:book) { Fabricate(:book) }
    it "should be rendered with BookSerializer" do
      get :show, id: book.id
      res = jsonfy(response.body)
      expect(response).to be_ok
      expect(res).to eq(BookSerializer.new(book).as_json)
    end
  end

  describe "#create" do
    context "successfully creates an Author" do
      let(:author) { Fabricate(:author) }
      let(:book_params) { Fabricate.attributes_for(:book, author_id: author.id, genre: 'mystery') }

      it "should return the created book" do
        post :create, book: book_params, token: user_1.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:title]).to eq(book_params[:title])
        expect(res[:genre]).to eq(book_params[:genre])
        expect(res[:author_name]).to eq(author.name)
        expect(res[:user_id]).to eq(user_1.id)
      end
    end
  end

  describe "#update" do
    let(:book) { Fabricate(:book, user: user_1) }
    let(:new_book_params) { { genre: 'crime', title: 'Murder on the Orient Express' } }

    context "User w/ normal role" do
      it "should be able to update his books successfully" do
        patch :update, id: book.id, book: new_book_params, token: user_1.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:id]).to eq(book.id)
        expect(res[:title]).to eq(new_book_params[:title])
        expect(res[:genre]).to eq(new_book_params[:genre])
        expect(res[:author_name]).to eq(book.author.name)
        expect(res[:user_id]).to eq(user_1.id)
      end

      it "should not be able to update books from other Users" do
        patch :update, id: book.id, book: new_book_params, token: user_2.remember_token
        res = jsonfy(response.body)
        expect(response).to be_unauthorized
        expect(res[:errors].first).to include('Not allowed to perform this action')
      end

      it "should not be able to update an books with invalid params" do
        patch :update, id: book.id, book: { author_id: nil }, token: user_1.remember_token
        res = jsonfy(response.body)
        expect(response).to be_unprocessable
        expect(res[:errors].first).to include("can't be blank")
      end
    end

    context "User w/ admin role" do
      let (:admin_user) { Fabricate(:admin_user).tap { |u| u.remember_me! } }

      it "should be able to update any Book" do
        patch :update, id: book.id, book: new_book_params, token: admin_user.remember_token
        res = jsonfy(response.body)
        expect(response).to be_ok
        expect(res[:id]).to eq(book.id)
        expect(res[:title]).to eq(new_book_params[:title])
        expect(res[:genre]).to eq(new_book_params[:genre])
        expect(res[:author_name]).to eq(book.author.name)
        expect(res[:user_id]).to eq(user_1.id)
      end
    end
  end

  describe "#destroy" do

    let(:book_1) { Fabricate(:book, user: user_1) }
    let(:book_2) { Fabricate(:book, user: user_2) }

    context "User w/ normal role" do
      it "should be able a User to delete his books" do
        book_id = book_1.id
        delete :destroy, id: book_id, token: user_1.remember_token
        expect(response).to be_ok
        expect { Book.find(book_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should not be able to delete books from other Users" do
        delete :destroy, id: book_2.id, token: user_1.remember_token
        res = jsonfy(response.body)
        expect(res[:errors].first).to include('Not allowed to perform this action')
        expect(response).to be_unauthorized
      end
    end

    context "User w/ admin role" do
      let (:admin_user) { Fabricate(:admin_user).tap { |u| u.remember_me! } }

      it "should be able to delete any Book" do
        [book_1.id, book_2.id].each do |book_id|
          delete :destroy, id: book_id, token: admin_user.remember_token
          expect(response).to be_ok
          expect { Book.find(book_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

end
