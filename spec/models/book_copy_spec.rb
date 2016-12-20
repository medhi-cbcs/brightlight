require 'rails_helper'

describe BookCopy do

  let(:title) { FactoryGirl.create(:book_title) }
  let(:edition) { FactoryGirl.create(:book_edition) }
  let(:year) { FactoryGirl.create :academic_year }
  let(:liz) { FactoryGirl.create :user }
  let(:mint) { FactoryGirl.create :new_condition }
  let(:copy) { FactoryGirl.create :book_copy }
  let(:mint_book) { FactoryGirl.create :new_book }
  let(:another_new_book) { FactoryGirl.create :new_book }
  let(:great_book) { FactoryGirl.create :good_book }     
  let(:so_so_book) { FactoryGirl.create :fair_book }
  let(:lost_book) { FactoryGirl.create :missing_book }
  let(:borrowed_book) { FactoryGirl.create :on_loan_book }

  # before do
  #   @copy = edition.book_copies.create(barcode:"INV-00011122")
  #   pp edition
  # end

  subject { copy }

  describe 'validity of its attribute' do
    it { should respond_to(:barcode) } 
    it { should respond_to(:book_edition) } 
    # expect(edition.book_copies).to include(@copy)
    # expect(@copy.book_edition).to eq edition 
  end 

  describe "creation in book edition" do
    it "should increment edition's copies count" do
      expect do
        edition.book_copies.create(barcode:"INV-11122233")
      end.to change(edition.book_copies, :count).by(1)
    end
  end

  describe "when barcode is not present" do
    before { copy.barcode = nil }
    it { should_not be_valid }
  end

  describe '.create_condition' do
    it "should increment edition's copies count" do
      expect do        
        copy.create_condition mint.id, year.id, liz.id
      end.to change(copy.copy_conditions, :count).by(1)
    end
  end

  describe 'filtering by condition' do
    before {
      pp mint 
      puts "There are #{BookCopy.count} copies"
      pp BookCopy.first
    }
    it "returns an array of results that match" do
      expect(BookCopy.with_condition(mint.id).to_a.count).to eq 2 #[mint_book, another_good_book] 
    end 
  end 
end
