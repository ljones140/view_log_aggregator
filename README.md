# View Log Aggregator

Takes a log file and returns the visit numbers and unique view numbers for each
page.

It also returns a list of invalid entries if the IP addresses are not
valid.

Given a file containing:
```
/about 85.180.202.126
/contact 234.118.158.12
/about 85.180.202.126
/about 85.180.202.126
/contact 234.118.158.10
/broken not_an_ip_address
```

`bin/parser <file>` will return:

```
+---------+------+
|Page name|visits|
+---------+------+
|/about   |3     |
|/contact |2     |
+---------+------+
+---------+------------+
|Page name|Unique Views|
+---------+------------+
|/contact |2           |
|/about   |1           |
+---------+------------+
Invalid Entries
/broken not_an_ip_address
```

## Setup
Assuming that you have Ruby installed via https://github.com/rbenv/rbenv

```sh
rbnev install
bundle install
```

## Run

To run script pass in your weblog file.

```sh
bin/parser <weblog.log>
```

**Note:** All of the IP addresses in the challenge `webserver.log` were invalid.

## Test Data Creation Script

This repo contains a script that creates sample weblog data.
It generates a weblog output containing page names and valid and invalid IP addresses.

```sh
bin/create_test_data
```

The below will send the output of `create_test_data` directly into the parser.

```sh
bin/parser <(bin/create_test_data) 
```

## Development Approach

Solution was created using Test Driven Development. Reading the repo commit by
commit will hopefully give insight into my process.

In an Object Orientated Programming approach the solution consists of several
domain objects, each with a specific responsibility.

`PageEntry` is responsible for keeping a record of visits to a page.
It can be asked how many visits the page has had and how many visitors from
unique IP addresses the page has received.

`PageViewAggregator` is responsible for creating the `PageEntry` objects, adding
visits to them and returning the result data.

IP addresses are represented as `IPAddr` objects. Using `ip_addr` from the
standard Ruby library.

`LogParser` orchestrates the process. It receives the file path from the shell,
opens and streams the file line by line into the `PageViewAggregator`.
Once file is streamed it takes the aggregator's result data sets and requests the
printer to print them.

The `Printer` prints data to the terminal. It has presentation logic.
It uses the `tty_table` gem to print tables to the terminal.

## Testing Approach

Run tests and `Rubocop` with:

```sh
bin/test
```

Unit tests exist for each object.
I have used dependency injection to test `LogParser`'s calls to Printer. This is
to ensure the correct data is being sent to the printer without having to
extensively stub `tty_table` extensively.

This does mean that there is lack of test coverage for Printer, I can accept
this as the Printers functionality is simple. I am reluctant to add further
tests that stub the `TTY::Prompt` class as that is not a class this system owns.

I prefer to use dependency injection over stubbing. I believe it
gives more control and avoids hidden side effects from mocking.

I avoid lets, before blocks and subjects when using `RSpec`.
Lets and before blocks can lead to the [Mystery Guest](http://xunitpatterns.com/Obscure%20Test.html#Mystery%20Guest)
anti pattern.

> The test reader is not able to see the cause and effect between fixture and
verification logic because part of it is done outside the Test Method.

I believe tests tell the reader more when the `it` block declares the setup
for the test.

Subject also compounds the mystery guest problem.
Use of subject in test examples was never intended by the `RSpec` authors.
See here in [docs](https://relishapp.com/rspec/rspec-core/v/3-9/docs/subject/explicit-subject)

> we recommend that you reserve it for support of custom
matchers and/or extension libraries that hide its use from examples.

### Static Analysis

`rubocop` used for static analysis with addition of `rubocop-rspec` and `rubocop-performance`
