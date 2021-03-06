# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'faker'

#Create fake standard users
10.times do 
  user = User.new(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: 'helloworld'
  )

   user.skip_confirmation!
   user.save!

end

users = User.all

#Creates admin user
admin = User.new(
  name: 'Admin User',
  email: 'floresjmjr@gmail.com',
  password: 'helloworld',
  role: 'admin'
	)

admin.skip_confirmation!
admin.save!




#Create fake wikis
30.times do 
  Wiki.create!(
    user: users.sample,
    title: Faker::Lorem.sentence(4),
    body: Faker::Lorem.paragraph(5)
  	)
end

wikis = Wiki.all

puts "Seeds finished"
puts "#{users.count} user seeds created"
puts "#{wikis.count} wikis seeds created"


