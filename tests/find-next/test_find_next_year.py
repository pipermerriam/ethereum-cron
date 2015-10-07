import datetime
import time
import pytest
import pytz


def to_timestamp(dt):
    offset = time.mktime(datetime.datetime(1970, 1, 1, tzinfo=pytz.UTC).timetuple())
    return int(time.mktime(dt.replace(tzinfo=pytz.UTC).timetuple()) - offset)


@pytest.mark.parametrize(
    "dt,pattern,dt_expected",
    (
        (datetime.datetime(1970, 1, 1), '1972', datetime.datetime(1972, 1, 1)),
        (datetime.datetime(1972, 3, 1), '1973', datetime.datetime(1973, 3, 1)),
        (datetime.datetime(1971, 3, 1), '1972', datetime.datetime(1972, 3, 1)),
        (datetime.datetime(1970, 1, 31), '1982', datetime.datetime(1982, 1, 31)),
        (datetime.datetime(1972, 2, 29), '2000', datetime.datetime(2000, 2, 29)),
        (datetime.datetime(1972, 2, 29), '1999', datetime.datetime(1999, 2, 28)),
    )
)
def test_find_next_year(crontab, dt, pattern, dt_expected):
    timestamp = to_timestamp(dt)
    actual = crontab.findNextYear(timestamp, pattern)
    expected = to_timestamp(dt_expected)
    assert actual == expected
