require 'csv'

# ===================== import product ine
products = {}
CSV.foreach("./import_files/product_file1.csv", {:headers => :first_row}) do |row|
  if row.nil? || row.empty? || row[0][0] == "#"
    next
  end
  hash = row.to_hash
  
  products[hash['product_id']] = hash  
end

# ====================== process transactions
transactions = {}
CSV.foreach("./import_files/transactions.csv", {:headers => :first_row}) do |row|
  if row.nil? || row.empty? || row[0][0] == "#"
    next
  end
  hash = row.to_hash
  
  item_trans = transactions[hash['product_id']]
  item_trans ||= []
  item_trans << hash
  transactions[hash['product_id']] = item_trans 
end

total_revenue = 0


# ======================== reporting results
puts "DETAIL REPORT"
products.each do |key, value|
  puts "  Product: #{value['name']}"
  high = low = avg = quantity = total_qty = count = revenue = 0
  
  transactions[value['product_id']].each do |transaction|
    count += 1
    quant = transaction['quantity'].to_i
    price = transaction['price'].to_f
    avg += price
    
    high = price if price > high
    low = price if (price < low) || (low == 0)
    total_qty += quant
    revenue += quant * price
    total_revenue += quant * price
  end
  avg = avg / count if count > 0
  
  puts "        High:#{high}"
  puts "        Low: #{low}"
  puts "        Avg: #{avg}"
  puts "        Total QTY: #{total_qty}"
  puts "        Total Revenue: #{revenue}"  
end

puts "\n\n >>>>>>>>  TOTOAL REVENUE: #{total_revenue}"




