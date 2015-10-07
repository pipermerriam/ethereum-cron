import pytest


@pytest.fixture(scope="module")
def crontab(deployed_contracts):
    return deployed_contracts.Crontab
