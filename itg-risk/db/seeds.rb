# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Initializing the nodes table \n"
Node.delete_all
Team.delete_all
User.delete_all
Attack.delete_all
#Defense.delete_all

puts "Define Attacks \n"
["Send Virus", "Send Worm", "Client Side Attacks", "Bruteforce"].each do |attack|
	Attack.create(:attack => attack)
end

#puts "Define Defense \n"
#["Send ", "Send Worm", "Client Side Attacks", "Bruteforce"].each do |attack|
#        Attack.create(:attack => attack)
#end

puts "Injecting new nodes \n"
open ("/home/ahmed/t") do |t|
	t.read.each_line do |ts|
		team,node,details,power,acquired,attack,defense = ts.chomp.split("|")
		Node.create!(:Team => team, :Node => node, :Details => details, :Power => power, :Aquired => acquired, :Attack => attack, :Defense => defense)
	end
end
