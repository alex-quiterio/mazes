class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :author_name, :user_id

  def initialize(object, options = {})
   super(object, options.merge(root: false))
  end

  def author_name
   object.author.name
  end
end
