# HashValley

Validate a hash with active model validations


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_valley'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hash_valley

## Usage

```
hash = {
  first_name: "",
  last_name: "Last",
  email: "first@last#error_email.com"
}

validations = {
  first_name: { presence: true },
  last_name: { inclusion: { in: ["Last", "Second Last"] }, allow_blank: true },
  email: { format: { with: URI::MailTo::EMAIL_REGEXP } }
}

validator = HashValidator.new(hash, validations)

validator.valid?
=> false

validator.errors.messages
=> {:first_name=>["can't be blank"], :email=>["is invalid"]}

```

for a list of the validations available:
https://guides.rubyonrails.org/active_record_validations.html

if you don't send in a validations hash then it will default to `presence: true`

To clear the validations: `HashValidator.clear_validators!` (needed if you are looping over an array of hashes and want validations for each element)
