namespace :db do
	desc "Populate book editions with fake prices"
	task fake_book_price: :environment do

    BookEdition.all.each do |edition|
      edition.update( {price: rand(4789)/100.0, currency:'USD'} )
    end
  end
end
