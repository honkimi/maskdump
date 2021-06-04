# maskdump

*this is develop version*

maskdump provides tools to help you dump data from RDBMS and mask their specified columns.  
You can use default masking method for masking data.  
For example, tel, email, blackout and so on. Otherwise, you program for custom masking method.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'maskdump'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install maskdump
```

## Usage


1. define mask target column and database settings

```yml
# tables.yml
---
user: root
password: pass
host: localhost
port: 3306
db: 
  name: sample_development
  rdbms: mysql
tables: 
  - name: owners
    columns: 
      - name: phone_number
        mask:
          type: tel # Data Masking Type
  - name: users
    columns: 
      - name: mail
        mask:
          type: email # Data Masking Type
          args:
            domain: hoge.com # Useful args for only part of masking types
      - name: name
        mask:
          type: replace # Data Masking Type
          args:
            to: anonymous # Useful args for only part of masking types
```

|Masking type|Description|Supported args|
|---|---|---|
|blackout|Replace strings with # of the same length.| |
|email|Replace with a unique and random email address. The domain will be @example.com by default, but you can specify any in the argument :domain.|:domain|
|replace|Replace with an arbitrary value. The argument :to is required.|:to|
|tel|Replace with a unique phone number.| |

2. check options

```
$ maskdump -h                                                                                                                                                                                                   +(master) 
Commands:
  maskdump dump            # dump
  maskdump help [COMMAND]  # Describe available commands or one specific command

Options:
  -d, [--database=database]            
  -u, [--user=user]                    
  -p, [--password=password]            
  -o, --output=output                  
  -v, [--verbose], [--no-verbose]      
  -a, [--data-only], [--no-data-only]  
```

3. execute maskdump command

```
$ maskdump dump tables.yml -o output.sql -v
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/maskdump. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

