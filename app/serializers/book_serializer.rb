class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :author_name

  def initialize(object, options = {})
   super(object, options.merge(root: false))
  end

  def author_name
   object.author.name
  end
end
