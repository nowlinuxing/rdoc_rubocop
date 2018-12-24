# RDocRuboCop

**RDocRuboCop** is a Ruby static code analyzer and formatter for codes in RDoc.

### before

```ruby
class Foo
  # concatenate each elements with ","
  #
  #   a = [ 1 , 2 , 3 ]
  #   foo=Foo.new
  #   foo.bar( a )
  #
  def bar(array)
    array.join(",")
  end
end
```

### after

```ruby
class Foo
  # concatenate each elements with ","
  #
  #   a = [1, 2, 3]
  #   foo = Foo.new
  #   foo.bar(a)
  #
  def bar(array)
    array.join(",")
  end
end

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rdoc_rubocop'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rdoc_rubocop

## Usage

    # Generate .rdoc_rubocop.yml and .rdoc_rubocop_todo.yml
    $ rdoc-rubocop --auto-gen-config

    # If .rubocop.yml already exists, and apply same cops to RDoc, edit .rdoc_rubocop.yml:
    #
    #   inherit_from: .rubocop.yml
    #   Style/FrozenStringLiteralComment:
    #     Enabled: false

    # Correct the code
    $ rdoc-rubocop -a

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nowlinuxing/rdoc_rubocop.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
