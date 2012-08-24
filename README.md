# Pretty Reliable Email
=====================

Why?
----

Regexes are not enough sometimes. We should go all the way and fully
parse the email and knock on the server's door to see if they really
have a mailbox. 

How?
---

### Basics     
    require 'pre'
    validator = Pre::Validator.new
    validator.valid? "me@apple.com"
    
### With basic config 

Pre by default has built in validators for RFC2822 and DNS MX record verification. Validators can be passed through the `:validators` option.

    require 'pre'
    # validate with no domain validation
    validator = Pre::Validator.new :validators => :format
    validator.valid? "foo@nonexistent201233.com" # => true

### Advanced config

Pre can take blocks for custom validators

  require 'pre'
  no_gmail = lambda do |address|
    address !~ /gmail.com$/
  end
  validator = Pre::Validator.new :validators => [:format, no_gmail]
  validator.valid? "foo@gmail.com" # => false
  
Pre can take any object that implements the valid? method

    require 'pre'
    class ComplexValidator
      def valid? address
        return true unless address =~ /gmail.com$/
        # do not allow user+label@gmail.com 
        address !~ /\+.+@/
      end
    end
    validator = Pre::Validator.new :validators => [:domain, ComplexValidator.new]
    validator.valid? "john+spam@gmail.com" # => false
 
 Pre can also take alternate configuration for a single address
 
  require 'pre'
  validator = Pre::Validator.new :validators => :format
  validator.valid? "john@example.co.uk", :validators => lambda { |address|
    address =~ /example.co.nz$/
  } # => false
    
### Caching
 
 Certain strategies may be more "intense" than others. MX Record lookup and other expensive operations can benefit from providing Pre with a cache store. A cache store must respond to `:write(key, val)` and `:read(key)` methods. The cache abstraction layer provided by Rails' [ActiveSupport::Cache::Store](http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html) fits this interface. 
 
    require 'pre'
    memcache = ActiveSupport::Cache::MemCacheStore.new("localhost", "server-downstairs.localnetwork:8229")
    validator = Pre::Validator.new :cache_store => memcache
    validator.valid? "foo@gmail.com" # => true
    

Contributing
---

  1. Fork
  2. Make tests
  3. Make changes to lib
  4. Ensure tests pass on 1.8/1.9 
  5. Submit request
  6. Smile
  
Roadmap
---

* ActiveModel, Mongoid::Document, etc.. integration
* DSL for configuring Pre validation configuration sets 

Ack
---

The RFC treetop grammars are pulled from the fantastic [mail](https://github.com/mikel/mail) gem.

