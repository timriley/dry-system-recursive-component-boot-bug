# dry-system recursive component boot bug

See:

1. [`lib/my_app/suppliers/books_n_stuff/source.rb`](lib/my_app/suppliers/books_n_stuff/source.rb), which auto-injects another dependency inside the `suppliers` namespace
2. [`system/boot/suppliers.rb`](system/boot/suppliers.rb), which tries to initialize BooksNStuff::Source
3. Which causes the auto-injector to resolve its dependency, `"suppliers.books_n_stuff.filter"`
4. Which `Dry::System::Container.load_component` notices has the same root key as a bootable component (`suppliers`)
5. So it tries to boot suppliers (_which is already in the process of being booted_)
6. `SystemStackError`

```
~/s/s/dry-system-bug (master) $ ./script/console
Traceback (most recent call last):
        11098: from ./script/console:4:in `<main>'
        11097: from ./script/console:4:in `require_relative'
        11096: from /Users/tim/Source/scratch/dry-system-bug/system/boot.rb:3:in `<top (required)>'
        11095: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-system-0.12.0/lib/dry/system/container.rb:300:in `finalize!'
        11094: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-system-0.12.0/lib/dry/system/booter.rb:65:in `finalize!'
        11093: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-system-0.12.0/lib/dry/system/booter/component_registry.rb:14:in `each'
        11092: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-system-0.12.0/lib/dry/system/booter/component_registry.rb:14:in `each'
        11091: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-system-0.12.0/lib/dry/system/booter.rb:66:in `block in finalize!'
         ... 11086 levels...
            4: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-system-0.12.0/lib/dry/system/components/bootable.rb:193:in `finalize'
            3: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/2.6.0/delegate.rb:83:in `method_missing'
            2: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-container-0.7.0/lib/dry/container/mixin.rb:200:in `each'
            1: from /Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-container-0.7.0/lib/dry/container/mixin.rb:73:in `config'
/Users/tim/.asdf/installs/ruby/2.6.2/lib/ruby/gems/2.6.0/gems/dry-configurable-0.8.3/lib/dry/configurable.rb:147:in `config': stack level too deep (SystemStackError)
```

To see it working normally, comment out `include Import["suppliers.books_n_stuff.filter"]` inside `lib/my_app/suppliers/books_n_stuff/source.rb`:

```
~/s/s/dry-system-bug (master) $ ./script/console
irb(main):001:0> MyApp::Container["suppliers.books_n_stuff.source"]
=> #<MyApp::Suppliers::BooksNStuff::Source:0x00007fdd50219eb0>
```
