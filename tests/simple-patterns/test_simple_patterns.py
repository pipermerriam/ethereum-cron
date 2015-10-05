def test_yearly(deployed_contracts):
    crontab = '0 0 0 1 1 *'
    assert False


def test_monthly(deployed_contracts):
    crontab = '0 0 0 1 * *'
    assert False


def test_weekly(deployed_contracts):
    crontab = '0 0 0 * * 0'
    assert False


def test_daily(deployed_contracts):
    crontab = '0 0 0 * * *'
    assert False


def test_hourly(deployed_contracts):
    crontab = '0 0 * * * *'
    assert False


