module Api
  module V1
    class SessionsController < ApplicationController

      skip_before_action :verify_authenticity_token

      def create
        user = User.find_by_email(params[:email])
        if user.present? && user.valid_password?(params[:password])
          user.remember_me!(session_ttl)
          render_json_dump({token: user.remember_me, ttl: session_ttl.from_now.to_s})
        else user.present?
          render_json_error('invalid email or password', status: :unprocessable_entity)
        end
      end

      def destroy
        if current_user.present?
          current_user.forget_me!
          head(:ok)
          return
        end
        head(:unprocessable_entity)
      end

      private

      def session_ttl
        2.hours
      end

    end
  end
end
