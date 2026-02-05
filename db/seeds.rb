# Create sample products
products = [
  { name: "Laptop", unit_price: 2999.99 },
  { name: "Mouse", unit_price: 49.90 },
  { name: "Keyboard", unit_price: 199.90 },
  { name: "Monitor", unit_price: 899.00 },
  { name: "Headphones", unit_price: 299.90 },
  { name: "Webcam", unit_price: 349.00 },
  { name: "USB Cable", unit_price: 29.90 },
  { name: "External HD 1TB", unit_price: 399.00 }
]

puts "Creating products..."
products.each do |product_data|
  product = Product.find_or_create_by!(name: product_data[:name]) do |p|
    p.unit_price = product_data[:unit_price]
  end
  puts "  ✓ #{product.name} - R$ #{product.unit_price}"
end

puts "\nSeed completed! #{Product.count} products available."
