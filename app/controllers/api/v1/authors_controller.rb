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

    end
  end
end
