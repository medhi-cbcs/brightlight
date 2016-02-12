class Forgery::CityIndonesia < Forgery
	def self.name
		dictionaries[:city_indonesia].random.unextend
	end
end