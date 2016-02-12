class Forgery::StreetNameIndonesia < Forgery
	def self.name
		dictionaries[:street_name_indonesia].random.unextend
	end
end