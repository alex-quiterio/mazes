require_dependency 'api/not_logged_in'
require_dependency 'json_error'

class ApplicationController < ActionController::Base

  include CanCan::ControllerAdditions, JsonError, Authenticable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do |exception|
   render_json_error('Not allowed to perform this action', status: :unauthorized)
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_json_error(exception.message, status: :bad_request)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
   render_json_error(exception, status: :not_found)
  end

  rescue_from Api::NotLoggedIn do |exception|
   render_json_error('Not Logged In', status: :unauthorized)
  end

  def render_serialized(obj, serializer, opts=nil)
    render_json_dump(serialize_data(obj, serializer, opts), opts)
  end

  def serialize_data(obj, serializer, opts=nil)
    # If it's an array, apply the serializer as an each_serializer to the elements
    serializer_opts = {}.merge!(opts || {})
    if obj.respond_to?(:to_ary)
      serializer_opts[:each_serializer] = serializer
      ActiveModel::ArraySerializer.new(obj.to_ary, serializer_opts).as_json
    else
      serializer.new(obj, serializer_opts).as_json
    end
  end

  def render_json_dump(obj, opts=nil)
    opts ||= {}
    if opts[:rest_serializer]
      obj['__rest_serializer'] = "1"
      opts.each do |k, v|
        obj[k] = v if k.to_s.start_with?("refresh_")
      end

      obj['extras'] = opts[:extras] if opts[:extras]
    end

    render json: MultiJson.dump(obj), status: opts[:status] || 200
  end

  def render_json_error(obj, opts={})
   opts = { status: opts } if opts.is_a?(Fixnum)
   render json: MultiJson.dump(create_errors_json(obj, opts[:type])), status: opts[:status] || 422
  end
end
