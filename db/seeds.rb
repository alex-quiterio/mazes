require 'ffaker'

[Book, Author, User].map(&:destroy_all)

# portuguese mini DB Books
books_collection = {
 'Fernando Pessoa' => [
  { title: 'A Mensagem', genre: :poetry },
  { title: 'O Livro do Desassosego', genre: :poetry }
 ],
 'Jose Saramago'   => [
  { title: 'Memorial do Convento', genre: :fantasy },
  { title: 'A Viagem do Elefante', genre: :fantasy },
  { title: 'As intermitencias da Morte', genre: :fantasy },
 ],
 'Valter Hugo Mãe' => [
  { title: 'O Filho de Mil Homens', genre: :romance },
  { title: 'O remorso de Baltazar Serapião', genre: :romance },
  { title: 'O Apocalipse dos trabalhadores', genre: :romance },
 ]
}

# Normal User
User.create(email: FFaker::Internet.email, password: 'enigma89', password_confirmation: 'enigma89', role: 'normal')
# Admin User
User.create(email: "mr_admin@guttenberg.com", password: 'ars inveniendi', password_confirmation: 'ars inveniendi', role: 'admin')

users  = User.all

books_collection.each do |author_name, books|
  author = Author.create(name: author_name, nationality: 'portuguese', user: users.sample)
  books.each do |book|
    author.books << Book.create(title: book[:title], genre: book[:genre], user: users.sample, author: author)
  end
end
