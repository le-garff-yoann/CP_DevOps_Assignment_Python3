import os
import requests

res = requests.get(os.getenv('PYTEST_BASE_URL'))


def test_status_code():
    assert 200 == res.status_code


def test_body_content():
    assert os.getenv('PYTEST_BODY_IN') in str(res.content)
