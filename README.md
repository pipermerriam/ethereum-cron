# Ethereum Crontab Parsing

Crontab parsing as an ethereum library contract.


# Quickstart

The Crontab contract exposes a single function ``next`` which returns the unix
timestamp of the next occurrence for a given crontab expression.

The supported cron expression are:

* ``ct_second``: 2 byte string with the second during which the entry
  should run or `*` to specify any second.
* ``ct_minute``: 2 byte string with the minute during which the entry
  should run or `*` to specify any minute.
* ``ct_hour``: 2 byte string with the hour during which the entry
  should run or `*` to specify any hour.
* ``cd_weekday``: 2 byte string with the day of the week or `*` to specify any
  weekday.  Weekdays are numbered 0-6 with Sunday being 0 and Saturday being 6.
* ``cd_day``: 2 byte string with the day of the month the entry should run or
  `*` to to specify any day.  Days are numbered 1-31
* ``cd_month``: 2 byte string with the month the entry should run or `*` to
  specify any month.  Months are numbered 1-12.
* ``cd_year``: 4 byte string with the year the entry should run or `*` to
  specify any year.

Crontab does not currently support complex cron expressions.  The `next`
function can be called any of the following ways.

* `function next(bytes2 ct_second, bytes2 ct_minute, bytes2 ct_hour, bytes2 ct_day, bytes2 ct_month, bytes2 ct_weekday, bytes2 ct_year) constant returns (uint)`

Returns the UNIX timestamp of the next occurrence for the provided expression
based on the current `now` value.

* `function next(bytes2 ct_second, bytes2 ct_minute, bytes2 ct_hour, bytes2 ct_day, bytes2 ct_month, bytes2 ct_weekday, bytes4 ct_year, uint timestamp) constant returns (uint)`

Returns the UNIX timestamp of the next occurrence for the provided expression
after the provided `timestamp`.
