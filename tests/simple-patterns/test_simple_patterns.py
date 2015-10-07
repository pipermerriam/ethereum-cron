import time
import datetime
import pytz


def to_timestamp(dt):
    offset = time.mktime(datetime.datetime(1970, 1, 1, tzinfo=pytz.UTC).timetuple())
    return int(time.mktime(dt.replace(tzinfo=pytz.UTC).timetuple()) - offset)


def test_yearly(crontab):
    dt_origin = datetime.datetime(2014, 5, 15, 1, 2, 3)
    now = to_timestamp(dt_origin)
    next_occurrence = crontab.next("0", "0", "0", "1", "1", "*", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.year == 2015
    assert dt.month == 1
    assert dt.day == 1
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_monthly(crontab):
    dt_origin = datetime.datetime(2014, 5, 15, 1, 2, 3)
    now = to_timestamp(dt_origin)
    next_occurrence = crontab.next("0", "0", "0", "1", "*", "*", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.year == 2014
    assert dt.month == 6
    assert dt.day == 1
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_weekly(crontab):
    dt_origin = datetime.datetime(2014, 5, 15, 1, 2, 3)
    now = to_timestamp(dt_origin)
    next_occurrence = crontab.next("0", "0", "0", "*", "*", "1", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.weekday() == 0  # Monday
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_daily(crontab):
    dt_origin = datetime.datetime(2014, 5, 15, 1, 2, 3)
    now = to_timestamp(dt_origin)
    next_occurrence = crontab.next("0", "0", "0", "*", "*", "*", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.day == 16
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_hourly(crontab):
    dt_origin = datetime.datetime(2014, 5, 15, 1, 2, 3)
    now = to_timestamp(dt_origin)
    next_occurrence = crontab.next("0", "0", "*", "*", "*", "*", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.hour == 2
    assert dt.minute == 0
    assert dt.second == 0
