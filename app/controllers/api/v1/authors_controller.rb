module Api
  module V1
    class AuthorsController < V1Controller

      before_action :insert_user_activity_on_resource, only: [:create]

      private

       def resource_scope
        params.key?(:user_id) ? User.find(params[:user_id]).authors : super
       end

       def resource_params
        params.require(:author).permit(:name, :nationality, :user_id)
       end

      # Authors Swagger Documentation
      #
      swagger_controller :authors, "Guttenberg Authors"
      swagger_api :index do
        summary "Fetches all Authors"
        notes "This lists all the Guttenberg Authors"
        param :path, :user_id, :integer, :optional, "Owner Id"
      end

      swagger_api :show do
        summary "Fetches a single Author"
        param :path, :id, :integer, :required, "Author Id"
        response :not_found
      end

      swagger_api :create do
        summary "Creates a new Author"
        param :form, 'author[name]', :string, :required, "Author Name"
        param :form, 'author[nationality]', :string, :required, "Author Nationality"
        response :unauthorized
        response :not_acceptable
      end

      swagger_api :update do
        summary "Updates an existing Author"
        param :path, :id, :integer, :required, "Author Id"
        param :form, 'author[name]', :string, :optional, "Author Name"
        param :form, 'author[nationality]', :string, :optional, "Author Nationality"
        response :unauthorized
        response :not_found
        response :not_acceptable
      end

      swagger_api :destroy do
        summary "Deletes an existing Author"
        param :path, :id, :integer, :required, "Author Id"
        response :unauthorized
        response :not_found
      end
    end
  end
end
