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
client.connection
```

> ### Create contact - [Api Reference](https://developers.activecampaign.com/reference#create-a-contact-new)

```ruby
client.create_contact({
    email:     'contact@email.com',
    firstName: 'first',
    lastName:  'last',
    phone:     '12312312'
})
```

> ### Sync contact (Create or Update) - [Api Reference](https://developers.activecampaign.com/reference#create-or-update-contact-new)

```ruby
client.sync_contact({
    email:     'contact@email.com',
    firstName: 'first',
    lastName:  'last',
    phone:     '12312312'
})
```

> ### Retrieve contact - [Api Reference](https://developers.activecampaign.com/reference#get-contact)

```ruby
client.retrieve_contact("contact_id")
```

> ### Retrieve contact by email

This will return an array of contacts.

```ruby
client.retrieve_contact_by_email("email")
```

> ### Retrieve lists - [Api Reference](https://developers.activecampaign.com/reference#retrieve-all-lists)

```ruby
client.retrieve_lists
```

> ### Create tag - [Api Reference](https://developers.activecampaign.com/reference#tags)

```ruby
client.create_tag({ 
    tag: "tag_name", tagType: "tag_type"  
})
```

> ### Add a tag to contact - [Api Reference](https://developers.activecampaign.com/reference#create-contact-tag)

It generates a relationship called contactTag containing an id.

```ruby
client.add_contact_tag({ 
    contact: "contact_id", tag: "tag_id"
})
```

> ### Remove a tag to contact - [Api Reference](https://developers.activecampaign.com/reference#delete-contact-tag)

To remove a tag from contact just remove the relationship between them.

```ruby
client.remove_contact_tag("contact_tag_id)
```

> ### Create field value - [Api Reference](https://developers.activecampaign.com/reference#create-fieldvalue)

It generates a relationship called fieldVaalue containing an id.

```ruby
client.create_field_value(
  {
    contact: 572218,
    field: 2,
    value: 'field_value'
  }
)
```

> ### Update a field value - [Api Reference](https://developers.activecampaign.com/reference#update-a-custom-field-value-for-contact)

It updates a relationship called fieldVaalue containing an id.

```ruby
client.update_field_value(
  803_383,
  {
    contact: 572218,
    field: 2,
    value: 'new_field_value_put'
  }
)
```

## Testing with your Api-Token

You can disable vcr in specs with these commands in your tests and create a new context for you.

```
WebMock.allow_net_connect!
VCR.turn_off!
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
