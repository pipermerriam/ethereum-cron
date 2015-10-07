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
        (datetime.datetime(1970, 1, 1), '5', datetime.datetime(1970, 1, 1, 0, 5)),
        (datetime.datetime(1970, 1, 1, 0, 10), '5', datetime.datetime(1970, 1, 1, 1, 5)),
        (datetime.datetime(1970, 1, 1, 0, 59), '58', datetime.datetime(1970, 1, 1, 1, 58)),
    )
)
def test_find_next_minute(crontab, dt, pattern, dt_expected):
    timestamp = to_timestamp(dt)
    actual = crontab.findNextMinute(timestamp, pattern)
    expected = to_timestamp(dt_expected)
    assert actual == expected
