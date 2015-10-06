import datetime


def test_yearly(deployed_contracts):
    crontab = deployed_contracts.Crontab
    next_occurrence = crontab.next("0", "0", "0", "1", "1", "*", "*")
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.month == 1
    assert dt.day == 1
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_monthly(deployed_contracts):
    crontab = deployed_contracts.Crontab
    next_occurrence = crontab.next("0", "0", "0", "1", "*", "*", "*")
    dt = datetime.datetime.utcfromtimestamp(next_occurrence)
    assert dt.day == 1
    assert dt.hour == 0
    assert dt.minute == 0
    assert dt.second == 0


def test_weekly(deployed_contracts):
    crontab = '0 0 0 * * 0'
    assert False


def test_daily(deployed_contracts):
    crontab = '0 0 0 * * *'
    assert False


def test_hourly(deployed_contracts):
    crontab = '0 0 * * * *'
    assert False
