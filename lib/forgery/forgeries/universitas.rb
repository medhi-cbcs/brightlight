class Forgery::Universitas < Forgery
	def self.universitas_negeri
		dictionaries[:universitas_negeri].random.unextend
	end

	def self.universitas_swasta
		dictionaries[:universitas_swasta].random.unextend
	end
end
