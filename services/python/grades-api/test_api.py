from fastapi.testclient import TestClient

from app import app

client = TestClient(app)
GRADES = [90, 80, 70]


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"


def test_average():
    r = client.post("/average", json={"grades": GRADES})
    assert r.status_code == 200
    assert r.json()["average"] == 80.0


def test_average_needs_grades():
    r = client.post("/average", json={"grades": []})
    assert r.status_code == 422
