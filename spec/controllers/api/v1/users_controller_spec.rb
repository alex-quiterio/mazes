# require 'rails_helper'

# describe Api::V1::UsersController, type: :controller do

#   before :each do
#     request.headers["Accept"] = "application/mysterious-v1+json"
#   end

#   describe "#show", focus: true do
#     before :each do
#       @user = Fabricate(:user)
#       get(:show, id: @user.id, format: :json)
#     end

#     it 'should return the user information' do
#       reply = JSON.parse(response.body, symbolize_names: true)
#       expect(reply[:user][:email]).to eql(@user.email)
#       expect(response.status).to eq(200)
#     end
#   end

#   describe "#create" do
#     context "successfully creating users" do
#       before(:each) do
#         @user_params = Fabricate.attributes_for(:user)
#         post(:create, { user: @user_params }, format: :json)
#       end

#         it "should return the created user" do
#           reply = JSON.parse(response.body, symbolize_names: true)
#           expect(reply[:user][:email]).to(eql @user_params[:email])
#           expect(response.status).to eq(201)
#       end
#     end

#     context "errors while creating users" do
#       before(:each) do
#         missing_params = { password: "le_password", password_confirmation: "le_password" }
#         post(:create, { user: missing_params }, format: :json)
#       end

#       it "should return an erroneus message" do
#         reply = JSON.parse(response.body, symbolize_names: true)
#         expect(reply[:errors][:email]).to include("can't be blank")
#         expect(response.status).to eq(422)
#       end
#     end
#   end

#   describe "#update" do
#     context "successfully updating the user" do
#       before(:each) do
#         @user = Fabricate(:user)
#         request.headers['Authorization'] =  @user.password
#         patch(:update, { id: @user.id, user: { email: "newemail@gutenberg.com" } }, format: :json)
#         expect(response.status).to eq(200)
#       end

#       it "should return the updated user information" do
#         reply = JSON.parse(response.body, symbolize_names: true)
#         expect(reply[:user][:email]).to eql("new@email.com")
#       end
#     end

#     context "errors while updating users" do
#       before(:each) do
#         @user = Fabricate(:user)

#         request.headers['Authorization'] =  @user.authentication_token
#         patch(:update, { id: @user.id, user: { email: "notthedroidyouarelookingfor" } }, format: :json)
#       end

#       it "should return an erroneus message" do
#         reply = JSON.parse(response.body, symbolize_names: true)
#         expect(reply[:errors][:email]).to include("is invalid")
#         expect(response.status).to eq(422)
#       end
#     end
#   end

#   describe "#destroy" do
#     context "successfully deletes the user" do
#       before(:each) do
#         @user = Fabricate(:user)
#         request.headers['Authorization'] =  @user.authentication_token

#         delete(:destroy, { id: @user.id }, format: :json)
#       end

#       it "should return 200" do
#         expect(response.status).to eq(200)
#       end
#     end
#   end
# end
