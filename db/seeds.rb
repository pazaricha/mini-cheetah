# This seeds file should only be run once via the rails db:seeds function

Rails.logger.info 'Creating a User'
user = FactoryBot.create(:user)
Rails.logger.info 'User created!'

Rails.logger.info 'Creating a ShoppingList for that User'
shopping_list = FactoryBot.create(:shopping_list, user: user)
Rails.logger.info 'ShoppingList created!'

# Import initial products and producers
Rails.logger.info 'Importing initial Products and Producers'
ProductsImporter.new.import
Rails.logger.info 'Products and Producers imported!'

# Create shopping_list_items for that shopping_list
Rails.logger.info "Creating ShoppingListItems for that User's ShoppingList"
Product.all.limit(100).each do |product|
  shopping_list.items.create(product: product, quantity: rand(1..100))
end
Rails.logger.info 'ShoppingListItems created!'

