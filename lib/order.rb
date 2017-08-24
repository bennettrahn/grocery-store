require 'csv'
require 'ap'

# og code using hash products
module Grocery
  class Order
    attr_reader :id, :products

    def initialize(id, products)
      @id = id
      @products = products
    end

    def total
      # TODO: implement total
      subtotal = @products.values.inject(0, :+)
      total = (subtotal * 1.075).round(2)
      return total
    end

    def add_product(product_name, product_price)
      # TODO: implement add_product
      if @products.keys.include?(product_name)
        return false
      else
        @products[product_name] = product_price
        return true
      end
    end

    def remove_product(product_name)
      if @products.keys.include?(product_name)
        @products.delete(product_name)
        return true
      else
        return false
      end
    end

    def self.all
      orders = []
      CSV.open("support/orders.csv", 'r').each do |line|
        id = line[0].to_i
        # line[1] = line[1].split(';')
        # line[1] = line[1].gsub!':' '=>'
        # products = line[1].to_h
        products_hash = {}
        products_arr = line[1].split';'
        products_arr.each do |item_colon_price|
          product_price = item_colon_price.split':'
          products_hash[product_price[0]] = product_price[1].to_f

        end

        orders << self.new(id, products_hash)

      end
      return orders
    end

    def self.find(id)
      orders = self.all
      unless (1..orders.length).include?(id)
        raise ArgumentError.new("Invalid id: #{id}")
      end

      found_order = nil
      orders.each do |order|
        if order.id == id
          found_order = order
        end
      end
      return found_order
    end
  end
end


# ap Grocery::Order.all
# ap Grocery::Order.find(4)
# ap Grocery::Order.find(4).products
