# Resolve

Convenient dependency resolution.


## Installation

Add this line to your application's Gemfile:

    gem 'resolve'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resolve

## Usage

A Class can declare its dependencies like this:

```

class Notifier
  depends_on :email_queue, sms_queue

  ...
end

```

Then, for example, I get an instance of `Notifier` with its dependencies satisfied...


```
Notifier.resolve(email_queue: my_instance_of_an_email_queue)
```

I specified the `email_queue` dependency explicitly. The `sms_queue` dependency will be assumed to follow a naming convention and a class `SmsQueue` will be resolved.

This happens recursively for dependencies.
Dependency names are global.


## Example Application

See how this is used in an [example application](http://github.com/sjltaylor/photoport)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
