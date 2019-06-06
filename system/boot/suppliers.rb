MyApp::Container.boot :suppliers, namespace: true do
  start do
    require "my_app/suppliers/books_n_stuff/source"

    source = MyApp::Suppliers::BooksNStuff::Source.new
    register "books_n_stuff.source", source
  end
end
