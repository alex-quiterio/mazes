module Api
 class V1Controller < ApplicationController

  respond_to :json
  before_action :authenticate!, only: [:create, :update, :destroy]

  # Ensure Swagger methods definition
  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private
    def setup_basic_api_documentation
      [:create, :update, :delete].each do |api_action|
        swagger_api api_action do
          param :header, 'Authentication', :string, :required, 'Authentication token'
        end
      end
    end
  end

   def index
    collection = load_collection
    present_data(collection)
   end

   def show
    resource = load_resource
    present_data(resource)
   end

   def create
    resource = build_resource
    save_resource(resource) ? present_data(resource) : present_error(resource)
   end

   def update
    resource = load_resource
    resource = build_resource(resource)
    save_resource(resource) ? present_data(resource) : present_error(resource)
   end

   def destroy
    resource = load_resource
    destroy_resource(resource) ? present_data(resource) : present_error(:unprocessable_entity)
   end

   private

   # resource definitions
   #
   def resource_scope
    resource_class.all
   end

   def resource_class
    resource_name.constantize
   end

   def resource_name
    controller_name.singularize.camelize
   end

   def resource_serializer
     "#{resource_name}Serializer".constantize
   end

   # params defined by each specific controller
   def resource_params; end

   # resource loaders
   #
   def load_collection
    @collection = resource_scope.to_a
   end

   def load_resource
    @resource = resource_scope.find(params[:id])
   end

   # resource actioners
   #
   def save_resource(resource)
    authorize!(action_name.intern, resource)
    !!resource.save
   end

   def insert_user_activity_on_resource
    (params[resource_name.downcase] || {})[:user_id] = current_user.id
   end

   def build_resource(resource=nil)
    resource ||= resource_class.new
    resource.attributes = resource_params
    resource
   end

   def destroy_resource(resource)
    authorize!(action_name.intern, resource)
    !!resource.destroy
   end

   # resource presenters
   #
   def present_data(object)
    render_serialized(object, resource_serializer)
   end

   def present_error(object)
    render_json_error(object)
   end
  end
end
