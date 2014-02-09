Descision Log

  * a service or dependency class constructors have an arity of one and take a hash of options
    * existing class can be overridden to fit this convention
  * cacheing of resolved services is up to the user
  * naming collisions for services can be avoided by passing in the dependency manually at the top level...
  * or by overriding Kernel#resolve
  * specify dependencies like so: :my_service or if its namespaced :'namespace/service'. you can also use strings
  * options are passed through the entire graph of dependencies


Naming Collisions

  * must be manually overridden by passing the dependency in via opts


Services which are not automatically resolveable classes such as

  * :url_helper when there is no such class
  * :my_service which is to be fullfilled by a Module

These

  * must be manually overridden by passing the dependency in via opts


Limitations

 * Rails convention: if the constant for a named dependency can't be resolved by "my_name".classify.constantize
   then the dependency will have to be resolved manually



# Resolve

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'resolve'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resolve

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
