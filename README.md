# Database
Simple, single-threaded, in-memory database.
A solution to a programming challenge. It is not intended for real use.

## Table of Contents

- [Description](#description)
  - [Commands](#commands)
  - [Transactions](#transactions)
  - [Time complexity](#time-complexity)
  - [Space complexity](#space-complexity)
- [Installation](#installation)
- [Usage](#usage)
  - [Database command interpreter](#database-command-interpreter)
  - [IRB](#irb)
  - [Spec](#spec)
  - [RuboCop](#RuboCop)

## Description

### Commands

The database should accept the following commands:
- `SET [name] [value]`: Set a variable `[name]` to the value `[value]`. Neither variable names nor values can contain spaces.
- `GET [name]`: Print out the value stored under the variable `[name]`. Print `NULL` if that variable name hasn't been set.
- `DELETE [name]`: Unset the variable `[name]`.
- `COUNT [value]`: Print out the number of variables equal to `[value]`. If no values are equal, this should output `0`.

Example:
```
> SET a 10
> GET a
10
> DELETE a
> GET a
NULL
> SET a 10
> SET b 10
> COUNT 10
2
> COUNT 20
0
> DELETE a
> COUNT 10
1
> SET b 30
> COUNT 10
0
```

### Transactions

In addition to the above data commands, your program should also support database transactions by also implementing these commands:
- `BEGIN`: Open a transactional block.
- `ROLLBACK`: Rollback all of the commands from the most recent transactional block.
- `COMMIT`: Permanently store all of the operations from any presently open transactional blocks.

Both `COMMIT` and `ROLLBACK` print out `NO TRANSACTION` if there are no open transactions.

The database should support nested transactional blocks. `ROLLBACK` only rolls back the most recent transaction block, while `COMMIT` closes all open transactional blocks. Any command issued outside of a transactional block commits automatically

Example 1:
```
> BEGIN
> SET a 10
> GET a
10
> BEGIN
> SET a 20
> GET a
20
> ROLLBACK
> GET a
10
> ROLLBACK
> GET a
NULL
```

Example 2:
```
> BEGIN
> SET a 30
> BEGIN
> SET a 40
> COMMIT
> GET a
40
> ROLLBACK
NO TRANSACTION
```

Example 3:
```
> SET a 50
> BEGIN
> GET a
50
> SET a 60
> BEGIN
> DELETE a
> GET a
NULL
> ROLLBACK
> GET a
60
> COMMIT
> GET a
60
```

Example 4:
```
> SET a 10
> BEGIN
> COUNT 10
1
> BEGIN
> DELETE a
> COUNT 10
0
> ROLLBACK
> COUNT 10
1
```

### Time complexity

The most commonly used commands are `GET`, `SET`, `DELETE` and `COUNT`, and each of these commands should be faster than O(log(N)) expected worst case, where N is the number of total variables stored in the database.
Hint: N does not depend on the number of open transactions T. For example, if N=1, T can be arbitrarily large.

### Space complexity

Typically, we will already have committed a lot of data when we begin a new transaction, but the transaction will only modify a few values. So, your solution should be efficient about how much memory is allocated for new transactions, i.e., it is bad if beginning a transaction nearly doubles your program's memory usage.

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

`GET`, `SET`, `DELETE`, `COUNT` and `BEGIN` take constant time.

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
