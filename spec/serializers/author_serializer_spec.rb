require 'rails_helper'
require 'spec_helper'

describe AuthorSerializer do

 let(:author) { u = Fabricate(:author) }
 let(:author_json) { { id: author.id, name: author.name, nationality: author.nationality, user_id: author.user_id, book_ids: author.book_ids } }
 subject { AuthorSerializer.new(author) }

 it { expect(subject.as_json).to eq(author_json) }

end
