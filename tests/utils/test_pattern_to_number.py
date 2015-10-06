import pytest


@pytest.mark.parametrize(
    'pattern,number',
    (
        ('1', 1),
        ('11', 11),
        ('1234', 1234),
        ('4321', 4321),
    )
)
def test_pattern_to_number(deployed_contracts, pattern, number):
    crontab = deployed_contracts.Crontab
    assert crontab._patternToNumber(pattern) == number;
