require 'spec_helper'

describe ActiveRecord::AttributeConverter do
  describe '#save' do
    let(:book) { Book.new(author: 'Author', title: 'Title', page: 24) }

    it 'converts attributes' do
      expect(book.title).to eq('Title')
      expect(book.page).to eq(24)
      book.save
      expect(book.title).to eq('Title')
      expect(book.page).to eq(24)
      expect(Book.where(['title = ?', 'Title'])).to_not exist
    end
  end

  describe 'query methods' do
    before do
      Book.create(author: 'Author', title: 'Title', page: 24)
    end

    describe 'find_by_*' do
      it 'finds record by external value' do
        expect(Book.find_by_author('Author')).to_not be_nil
        expect(Book.find_by_title('Title')).to_not be_nil
        expect(Book.find_by_author_and_page('Author', 24)).to_not be_nil
        expect(Book.find_by_title_and_page('Title', 24)).to_not be_nil
      end
    end

    describe 'where' do
      it 'finds records by Hash' do
        expect(Book.where(author: 'Author')).to exist
        expect(Book.where(title: 'Title')).to exist
        expect(Book.where(author: 'Author', page: 24)).to exist
        expect(Book.where(title: 'Title', page: 24)).to exist
      end

      it "doesn't support String/Array finder" do
        expect(Book.where(['author = ?', 'Author'])).to exist
        expect(Book.where(['title = ?', 'Title'])).to_not exist
        expect(Book.where(['page = ?', 24])).to_not exist
        expect(Book.where('page = 24')).to_not exist
      end
    end
  end

  describe 'update methods' do
    let!(:book) { Book.create(author: 'Author', title: 'Title', page: 24) }

    describe 'update_column' do
      it 'converts attributes' do
        book.update_column(:title, 'New Title')
        expect(book.title).to eq('New Title')
        expect(Book.where(title: 'New Title')).to exist
      end
    end

    describe 'update_all' do
      it 'converts attributes by Hash' do
        Book.where(author: 'Author').update_all(page: 100)
        expect(book.reload.page).to eq(100)
        expect(Book.where(page: 100)).to exist
        expect(Book.where('page = ?', 100)).to_not exist
      end

      it "doesn't support String/Array" do
        Book.where(author: 'Author').update_all(['page = ?', 100])
        expect(book.reload.page).to_not eq(100)
        expect(Book.where(page: 100)).to_not exist
        expect(Book.where('page = ?', 100)).to exist
      end
    end
  end
end
