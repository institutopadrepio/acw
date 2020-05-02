# Acw

This is a very simple wrapper of the Active Campaign Api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acw'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acw

## Usage

> ### Initialize client

```ruby
client = Acw::Client.new({
    url:   'your-url',
    token: 'your-token'
})
```

> ### Connection details

```ruby
client = Acw::Client.new({
    url:   'your-url',
    token: 'your-token'
})

client.connection
```

> ### Create contact

```ruby
client.create_contact({
    email:     'contact@email.com',
    firstName: 'first',
    lastName:  'last',
    phone:     '12312312'
})
```

> ### Sync contact (Create or Update)

```ruby
client.sync_contact({
    email:     'contact@email.com',
    firstName: 'first',
    lastName:  'last',
    phone:     '12312312'
})
```

> ### Retrieve contact

```ruby
client.retrieve_contact("contact_id")
```

> ### Retrieve contact by email

This will return an array of contacts.

```ruby
client.retrieve_contact_by_email("email")
```

> ### Retrieve lists

```ruby
client.retrieve_lists
```

> ### Create tag

```ruby
client.create_tag({ 
    tag: "tag_name", tagType: "tag_type"  
})
```

> ### Add a tag to contact

It generates a relationship called contactTag containing an id.

```ruby
client.add_contact_tag({ 
    contact: "contact_id", tag: "tag_id"
})
```

> ### Remove a tag to contact

To remove a tag from contact just remove the relationship between them.

```ruby
client.remove_contact_tag("contact_tag_id)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
