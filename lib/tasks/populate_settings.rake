namespace :db do
	desc "Populate database with settings"
	task populate_settings: :environment do

		BookCondition.delete_all
		Status.delete_all

		[{code:'New',  description:'New book', color: 'blue'},
		 {code:'Good', description:'Slightly used', color: 'green'},
		 {code:'Fair', description:'Heavily used', color: 'orange'},
		 {code:'Poor', description:'Very heavily used', color: 'red'},
		 {code: 'Missing', description: 'Lost / Missing', color: 'maroon' }
		].each do |condition|
			BookCondition.create(code:condition[:code], description:condition[:description])
		end

		[{name:'Available', order_no: 1},
		 {name:'On loan', order_no: 2},
		 {name:'In repair', order_no: 3},
		 {name:'Missing', order_no: 4}
		].each do |status|
		 	Status.create(name:status[:name], order_no:status[:order_no])
		end
	end
end
