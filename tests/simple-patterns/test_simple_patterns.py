import time
import datetime


def to_timestamp(dt):
    offset = time.mktime(datetime.datetime(1970, 1, 1).timetuple())
    return int(time.mktime(dt.timetuple()) - offset)


def test_yearly(deployed_contracts):
    crontab = deployed_contracts.Crontab
    dt_now = datetime.datetime.now()
    now = to_timestamp(dt_now)
    next_occurrence = crontab.next("0", "0", "0", "1", "1", "*", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.year == dt_now.year + 1
    assert dt.month == 1
    assert dt.day == 1
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_monthly(deployed_contracts):
    crontab = deployed_contracts.Crontab
    dt_now = datetime.datetime.now()
    now = to_timestamp(dt_now)
    next_occurrence = crontab.next("0", "0", "0", "1", "*", "*", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.month == dt_now.month + 1 if dt_now.month < 12 else 1
    assert dt.day == 1
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_weekly(deployed_contracts):
    crontab = '0 0 0 * * 0'
    crontab = deployed_contracts.Crontab
    dt_now = datetime.datetime.now()
    now = to_timestamp(dt_now)
    next_occurrence = crontab.next("0", "0", "0", "*", "*", "1", "*", now)
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.weekday() == 0  # Monday
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_daily(deployed_contracts):
    crontab = '0 0 0 * * *'
    assert False


def test_hourly(deployed_contracts):
    crontab = '0 0 * * * *'
    assert False
