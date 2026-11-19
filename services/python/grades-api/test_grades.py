from grades import average, passed


def test_average_and_pass_mark():
    assert average([100, 55]) == 77.5
    assert passed(60)
    assert not passed(59.9)
