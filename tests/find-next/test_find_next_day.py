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
        (datetime.datetime(1970, 1, 1), '5', datetime.datetime(1970, 1, 5)),
        (datetime.datetime(1970, 1, 2), '1', datetime.datetime(1970, 2, 1)),
        (datetime.datetime(1970, 2, 1), '31', datetime.datetime(1970, 3, 31)),
        (datetime.datetime(1970, 12, 15), '3', datetime.datetime(1971, 1, 3)),
        (datetime.datetime(1970, 4, 1), '31', datetime.datetime(1970, 5, 31)),
    )
)
def test_find_next_day(crontab, dt, pattern, dt_expected):
    timestamp = to_timestamp(dt)
    actual = crontab.findNextDay(timestamp, pattern)
    expected = to_timestamp(dt_expected)
    assert actual == expected
