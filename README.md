# Database
Simple, single-threaded, in-memory database

## Installation

Developed and tested on Ruby version 3.2.

    $ bundle install

## Usage

### Database command interpreter

    $ exe/database

Example session:
```
$ exe/database
> set a 10
> get a
10
> delete a
> get a
NULL
> set a 10
> set b 10
> count 10
2
> commit
NO TRANSACTION
> 
$
```
exit with EOF (Ctrl + D)

### IRB

    $ bin/console

### Spec

    $ bundle exec rake spec

Example output:
```
$ bundle exec rake spec
/usr/share/rvm/rubies/ruby-3.2.3/bin/ruby -I/usr/share/rvm/gems/ruby-3.2.3/gems/rspec-core-3.12.2/lib:/usr/share/rvm/gems/ruby-3.2.3/gems/rspec-support-3.12.1/lib /usr/share/rvm/gems/ruby-3.2.3/gems/rspec-core-3.12.2/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb

Database::CommandInterpreter
  example
    reads commands and outputs results
  example 1
    reads commands and outputs results
  example 2
    reads commands and outputs results
  example 3
    reads commands and outputs results
  example 4
    reads commands and outputs results

Database::Database
  set
    assigns a value to a variable
    increments count of the assigned value
    decrements count of the previous variable value
  get
    returns nil if the variable has not been assigned
    returns value assigned to a variable
  delete
    clears the variable
    decrements count of the previous variable value
  count
    returns count of the assigned value
  commit
    returns false if there are no transactions in progress
  rollback
    returns false if there are no transactions in progress

Database
  has a version number

Finished in 0.00968 seconds (files took 0.05134 seconds to load)
16 examples, 0 failures
```

### RuboCop

    $ bundle exec rake rubocop

Output:
```
$ bundle exec rake rubocop
Running RuboCop...
Inspecting 14 files
..............

14 files inspected, no offenses detected
```
