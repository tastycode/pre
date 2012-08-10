Pretty Reliable Email
=====================

Why?
----

Regexes are not enough sometimes. We should go all the way and fully
parse the email and knock on the server's door to see if they really
have a mailbox. 

How?
---
    
    require 'pre'
    validator = Pre::Validator.new("me@apple.com")
    validator.valid?

Contributing
---

  1. Fork
  2. Make tests
  3. Make changes to lib
  4. Ensure tests pass on 1.8/1.9 
  5. Submit request
  6. Smile

Ack
---

The RFC treetop grammars are pulled from the fantastic [mail](https://github.com/mikel/mail) gem.
