namespace :db do
	desc "Populate database with book labels"
	task fill_in_labels_in_book_copy: :environment do

    BookCopy.all.each do |copy|
      label = BookLabel.where(name:copy.copy_no).first
      copy.update_attribute(:book_label_id,label.id)
    end
  end
end
