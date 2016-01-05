require 'rails_helper'
require 'spec_helper'

describe Book do

		it { is_expected.to validate_presence_of :title }
		it { is_expected.to validate_presence_of :author }
	 context "#factory" do
    it 'should be valid' do
      expect(Fabricate(:book)).to be_valid
    end
  end

  context "domain" do
   it 'should only have an author' do
    author_1 = Fabricate(:author)
    author_2 = Fabricate(:author)
    book = Fabricate(:book, author: author_1)
    author_2.books << book
    expect(book.author).to eq(author_2)
   end
  end

end
