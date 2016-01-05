module Api
  module V1
    class BooksController < V1Controller

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
        params.require(:book).permit(:title, :category, :user_id, :author_id, :book_ids => [])
      end

    end
  end
end
