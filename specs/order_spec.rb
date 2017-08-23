require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/order'



describe "Order Wave 1" do
  describe "#initialize" do
    it "Takes an ID and collection of products" do
      id = 1337
      order = Grocery::Order.new(id, {})

      order.must_respond_to :id
      order.id.must_equal id
      order.id.must_be_kind_of Integer

      order.must_respond_to :products
      order.products.length.must_equal 0
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      sum = products.values.inject(0, :+)
      expected_total = sum + (sum * 0.075).round(2)

      order.total.must_equal expected_total
      #might need to test .00 round?
    end

    it "Returns a total of zero if there are no products" do
      order = Grocery::Order.new(1337, {})

      order.total.must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      order.products.count.must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.add_product("sandwich", 4.25)
      order.products.include?("sandwich").must_equal true
    end

    it "Returns false if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Grocery::Order.new(1337, products)
      before_total = order.total

      result = order.add_product("banana", 4.25)
      after_total = order.total

      result.must_equal false
      before_total.must_equal after_total
    end

    it "Returns true if the product is new" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      result = order.add_product("salad", 4.25)
      result.must_equal true
    end
  end

  describe "#remove_product" do
    it "decreases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00, "salad" => 4.25 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.remove_product("salad")
      expected_count = before_count - 1
      order.products.count.must_equal expected_count
    end

    it "Is removed from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00, "sandwich" => 4.25}
      order = Grocery::Order.new(1337, products)

      order.remove_product("sandwich")
      order.products.include?("sandwich").must_equal false
    end

    it "Returns false if the product is not removed" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Grocery::Order.new(1337, products)
      before_total = order.total

      result = order.remove_product("sandwich")
      after_total = order.total

      result.must_equal false
      before_total.must_equal after_total
    end

    it "Returns true if the product is removed" do
      products = { "banana" => 1.99, "cracker" => 3.00, "salad" => 4.25 }
      order = Grocery::Order.new(1337, products)

      result = order.remove_product("salad")
      result.must_equal true
    end
  end
end


describe "Order Wave 2" do
  describe "Order.all" do
    before do
      @orders = Grocery::Order.all
    end
    it "Returns an array" do
      @orders.must_be_kind_of Array
    end

    it "Array is filled with Orders" do
      10.times do
        @orders[rand(100)].must_be_kind_of Order
      end
    end

    it "Has right number of items" do
      @orders.length.must_equal 100
    end

    it "first and last are same as csv" do
      orders_first = 	[1, {"Slivered Almonds" => 22.88, "Wholewheat flour" => 1.93, "Grape Seed Oil" => 74.9}]

      @orders.first.must_equal orders_first

      orders_last = [100, {"Allspice" => 64.74, "Bran" => 14.72, "UnbleachedFlour" => 80.59}]

      @orders.last.must_equal orders_last
    end

      # TODO: Your test code here!
      # Useful checks might include:
      ##   - Order.all returns an array
      ##   - Everything in the array is an Order
      ##   - The number of orders is correct
      #   - The ID and products of the first and last
      #       orders match what's in the CSV file
      # Feel free to split this into multiple tests if needed
    
  end
end
#   describe "Order.find" do
#     it "Can find the first order from the CSV" do
#       # TODO: Your test code here!
#     end
#
#     it "Can find the last order from the CSV" do
#       # TODO: Your test code here!
#     end
#
#     it "Raises an error for an order that doesn't exist" do
#       # TODO: Your test code here!
#     end
#   end
# end
