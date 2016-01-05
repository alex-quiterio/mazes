Fabricator(:author) do
  name { FFaker::Name.name  }
  nationality { ['portuguese', 'english', 'dutch'].sample }
end

Fabricator(:author_with_books, from: :author) do
  books(count: 2)
end
