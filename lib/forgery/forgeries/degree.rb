class Forgery::Degree < Forgery
	def self.sarjanaS1
		dictionaries[:sarjana_S1].random.unextend
	end

	def self.sarjanaS2
		dictionaries[:sarjana_S2].random.unextend
	end
end
