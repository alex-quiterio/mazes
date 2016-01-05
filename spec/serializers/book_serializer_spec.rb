require 'rails_helper'
require 'spec_helper'

describe BookSerializer do

 let(:book) { u = Fabricate(:book) }
 let(:book_json) { { id: book.id, title: book.title, genre: book.genre, author_name: book.author.name } }
 subject { BookSerializer.new(book) }

 it { expect(subject.as_json).to eq(book_json) }

end
