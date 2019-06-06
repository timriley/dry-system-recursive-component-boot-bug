module MyApp
  module Suppliers
    module BooksNStuff
      class Filter
        def call(input)
          input.reverse
        end
      end
    end
  end
end
