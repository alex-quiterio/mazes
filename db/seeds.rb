[Book, Author, User].map(&:destroy_all)

# portuguese mini DB Books
books_collection = {
 'Fernando Pessoa' => [
  { title: 'O Livro do Desassosego', genre: :undefined }
 ],
 'Jose Saramago'   => [
  { title: 'Memorial do Convento', genre: :fantasy },
  { title: 'A Viagem do Elefante', genre: :fantasy },
  { title: 'As intermitencias da Morte', genre: :fantasy },
 ]
}

# Normal User
User.create(email: FFaker::Internet.email, password: 'enigma', password_confirmation: 'enigma', role: 'normal')
# Admin User
User.create(email: "admin@guttenberg.com", password: 'ars inveniendi', password_confirmation: 'ars inveniendi', role: 'admin')

users  = User.all

books_collection.each do |author_name, books|
  author = Author.create(name: author_name, nationality: 'portuguese', user: users.sample)
  books.each do |book|
    author.books << Book.create(title: book[:title], genre: book[:genre], user: author.user, author: author)
  end
end
