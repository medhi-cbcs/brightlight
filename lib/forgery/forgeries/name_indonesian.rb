class Forgery::NameIndonesian < Forgery
	def self.name
		dictionaries[:name_indonesian].random.unextend
	end
end