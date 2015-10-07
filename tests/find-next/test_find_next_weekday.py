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
        # Thursday -> Friday
        (datetime.datetime(1970, 1, 1), '5', datetime.datetime(1970, 1, 2)),
        # Thursday -> Sunday
        (datetime.datetime(1970, 1, 1), '0', datetime.datetime(1970, 1, 4)),
        # Thursday -> Wednesday
        (datetime.datetime(1970, 1, 1), '3', datetime.datetime(1970, 1, 7)),
    )
)
def test_find_next_weekday(crontab, dt, pattern, dt_expected):
    timestamp = to_timestamp(dt)
    actual = crontab.findNextWeekday(timestamp, pattern)
    expected = to_timestamp(dt_expected)
    assert actual == expected
