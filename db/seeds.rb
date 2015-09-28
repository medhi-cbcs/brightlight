# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all

Product.create!(title: 'Saxon Math Algebra 1',
	description:
		%{Students who are interested in taking the Saxon Geometry course may choose the 4th Edition Algebra 1 and Algebra 2 courses, which are designed to accompany Geometry. Featuring the same incremental approach that is the hallmark of the Saxon Program, the 4th Edition Algebra 1 and Algebra 2 textbooks feature more algebra and precalculus content and fewer geometry lessons than their 3rd Edition counterparts.},
	image_url: 'http://ecx.images-amazon.com/images/I/51jbbrP1VTL._SX358_BO1,204,203,200_.jpg',
	price: 116.46
	)

Product.create!(title: 'Algebra 2 Saxon Teacher\'s Edition 2009',
	description:
		%{Teachers edition},
	image_url: 'http://ecx.images-amazon.com/images/I/510Y6RinkzL._SY344_BO1,204,203,200_QL70_.jpg',
	price: 79.0
	)

Product.create!(title: 'Chemistry: A Molecular Approach (3rd Edition)',
	description:
		%{Chemistry: A Molecular Approach, Third Edition is an innovative, pedagogically driven text that explains challenging concepts in a student-oriented manner.  Nivaldo Tro creates a rigorous and accessible treatment of general chemistry in the context of relevance and the big picture. Chemistry is presented visually through multi-level images–macroscopic, molecular, and symbolic representations–helping students see the connections between the world they see around them (macroscopic), the atoms and molecules that compose the world (molecular), and the formulas they write down on paper (symbolic). The hallmarks of Dr. Tro’s problem-solving approach are reinforced through interactive media that provide students with an office-hour type of environment built around worked examples and expanded coverage on the latest developments in chemistry. Pioneering features allow students to sketch their ideas through new problems, and much more.},
	image_url: 'http://ecx.images-amazon.com/images/I/51S40Hz-%2BUL._SX387_BO1,204,203,200_.jpg',
	price: 97.98
	)

Product.create!(title: 'The Story of the World: History for the Classical Child: Volume 1: Ancient Times: From the Earliest Nomads to the Last Roman Emperor, Revised Edition',
	description:
		%{This first book in the four-volume narrative history series for elementary students will transform your study of history. The Story of the World has won awards from numerous homeschooling magazines and readers' polls―over 150,000 copies of the series in print!},
	image_url: 'http://ecx.images-amazon.com/images/I/412I44TOmNL._SX316_BO1,204,203,200_.jpg',
	price: 10.43
	)

Product.create!(title: 'The Story of the World: History for the Classical Child: The Middle Ages: From the Fall of Rome to the Rise of the Renaissance (Second Revised Edition) (Vol. 2) (Story of the World)',
	description:
		%{This second book in the four-volume narrative history series for elementary students will transform your study of history. The Story of the World has won awards from numerous homeschooling magazines and readers' polls―over 150,000 copies of the series in print!},
	image_url: 'http://ecx.images-amazon.com/images/I/41x0d0r4KqL._SX316_BO1,204,203,200_.jpg',
	price: 12.99
	)

Product.create!(title: 'The Story of the World: History for the Classical Child, Volume 3: Early Modern Times',
	description:
		%{This third book in the four-volume narrative history series for elementary students will transform your study of history. The Story of the World has won awards from numerous homeschooling magazines and readers' polls―over 150,000 copies of the series in print!},
	image_url: 'http://ecx.images-amazon.com/images/I/415KCgeu6kL._SX293_BO1,204,203,200_.jpg',
	price: 11.6
	)

Product.create!(title: 'The Story of the World: History for the Classical Child, Volume 4: The Modern Age: From Victoria\'s Empire to the End of the USSR',
	description:
		%{This fourth book in the four-volume narrative history series for elementary students will transform your study of history. The Story of the World has won awards from numerous homeschooling magazines and readers' polls―over 150,000 copies of the series in print!},
	image_url: 'http://ecx.images-amazon.com/images/I/41WU-FczVQL._SX289_BO1,204,203,200_.jpg',
	price: 12.2
	)