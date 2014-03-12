# ActiveRecord::AttributeConverter

Transparent conversion for ActiveRecord.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-attribute_converter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-attribute_converter

## Usage

```ruby
class Plus10
  def internalize(n)
    n+10
  end

  def externalize(n)
    n-10
  end
end

class Rot13
  def internalize(str)
    str.tr('A-Za-z', 'N-ZA-Mn-za-m')
  end

  def externalize(str)
    internalize(str)
  end
end

class Book < ActiveRecord::Base
  apply_converter :page, Plus10.new
  apply_converter :title, Rot13.new
end
```

```ruby
book = Book.create(author: 'Author', title: 'Title', page: 24)
p book.author   # => "Author"
p book.title    # => "Title"
p book.page     # => 24

in_db = Book.connection.execute('SELECT * FROM books').first
p in_db['author']   # => "Author"
p in_db['title']    # => "Gvgyr"
p in_db['page']     # => 34

p Book.where(title: 'Title').map(&:title)    # => ["Title"]
```

## Contributing

1. Fork it ( https://github.com/eagletmt/activerecord-attribute_converter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
