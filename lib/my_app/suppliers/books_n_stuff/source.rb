require "my_app/import"

module MyApp
  module Suppliers
    module BooksNStuff
      class Source
        include Import["suppliers.books_n_stuff.filter"]

        def call(input)
          filter.(input)
        end
      end
    end
  end
end
