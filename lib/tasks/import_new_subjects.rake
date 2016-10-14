namespace :data do
	desc "Import new subjects"
	task import_new_subjects: :environment do

    xl = Roo::Spreadsheet.open('lib/tasks/Subject List.xlsx')
    sheet = xl.sheet('subjects')

    header = {code:'Code',name:'Name',description:'Notes'}

    sheet.each_with_index(header) do |row,i|
			next if i < 1
      subject = Subject.new(
                  code:       row[:code],
                  name:       row[:name],
                  description:     row[:description]
                )
      subject.save
      puts "#{i}. #{subject.code} #{subject.name} #{subject.description}"
    end

    BookTitle.all.each do |b|
      b.update_attribute :subject_id, Subject.find_by_code(b.subject).try(:id)
    end
  end
end
