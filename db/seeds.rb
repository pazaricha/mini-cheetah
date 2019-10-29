# This seeds file should only be run once via the rails/rake db:seed function

puts 'Creating a User'
user = FactoryBot.create(:user)
puts 'User created!'

puts 'Creating a ShoppingList for that User'
shopping_list = FactoryBot.create(:shopping_list, user: user)
puts 'ShoppingList created!'

# Import initial products and producers
puts 'Importing initial Products and Producers'
ProductsImporter.new.import
puts 'Products and Producers imported!'

# Create shopping_list_items for that shopping_list
puts "Creating ShoppingListItems for that User's ShoppingList"
Product.all.limit(100).each do |product|
  shopping_list.items.create(product: product, quantity: rand(1..100))
end
puts 'ShoppingListItems created!'

