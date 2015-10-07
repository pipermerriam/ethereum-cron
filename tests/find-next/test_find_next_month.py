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
        (datetime.datetime(1970, 1, 1), '5', datetime.datetime(1970, 5, 1)),
        (datetime.datetime(1970, 2, 1), '1', datetime.datetime(1971, 1, 1)),
        (datetime.datetime(1970, 1, 31), '2', datetime.datetime(1970, 2, 28)),
        (datetime.datetime(1972, 1, 31), '2', datetime.datetime(1972, 2, 29)),
        (datetime.datetime(1970, 12, 31), '4', datetime.datetime(1971, 4, 30)),
    )
)
def test_find_next_month(crontab, dt, pattern, dt_expected):
    timestamp = to_timestamp(dt)
    actual = crontab.findNextMonth(timestamp, pattern)
    expected = to_timestamp(dt_expected)
    assert actual == expected
