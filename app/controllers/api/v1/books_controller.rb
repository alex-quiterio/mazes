module Api
  module V1
    class BooksController < V1Controller

      before_action :insert_user_activity_on_resource, only: [:create]

      private

      def resource_scope
        if params.key?(:author_id)
          Author.find(params[:author_id]).books
        elsif params.key?(:user_id)
          User.find(params[:user_id]).books
        else
          super
        end
      end

      def resource_params
        params.require(:book).permit(:title, :genre, :user_id, :author_id)
      end

      # Books Swagger Documentation
      #
      swagger_controller :books, "Guttenberg Books"
      swagger_api :index do
        summary "Fetches all Books"
        param :path, :user_id, :integer, :optional, "Owner Id"
        param :path, :author_id, :integer, :optional, "Author Id"
      end

      swagger_api :show do
        summary "Fetches a single Book"
        param :path, :id, :integer, :required, "Book Id"
        response :not_found
      end

      swagger_api :create do
        summary "Creates a new Book"
        param :form, 'book[title]', :string, :required, "Book Title"
        param :form, 'book[author_id]', :string, :required, "Author's Book"
        param_list :form, 'book[genre]', :string, :required, "Book Genre", Book.genres.keys
        response :unauthorized
        response :not_acceptable
      end

      swagger_api :update do
        summary "Updates an existing Book"
        param :path, :id, :integer, :required, "Book Id"
        param :form, 'book[title]', :string, :required, "Book Title"
        param :form, 'book[author_id]', :string, :required, "Author's Book"
        param_list :form, 'book[genre]', :string, :required, "Book Genre", Book.genres.keys
        response :unauthorized
        response :not_found
        response :not_acceptable
      end

      swagger_api :destroy do
        summary "Deletes an existing Book"
        param :path, :id, :integer, :required, "Book Id"
        response :unauthorized
        response :not_found
      end

    end
  end
end
