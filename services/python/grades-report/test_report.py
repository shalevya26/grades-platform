import pytest

from report import load, summary


def test_summary():
    assert summary([100, 55, 60]) == {"count": 3, "average": 71.7, "pass_rate": 66.7}


def test_summary_needs_grades():
    with pytest.raises(ValueError):
        summary([])


def test_load(tmp_path):
    f = tmp_path / "g.csv"
    f.write_text("student,grade\nana,90\nben,58.5\n")
    assert load(str(f)) == [90.0, 58.5]
