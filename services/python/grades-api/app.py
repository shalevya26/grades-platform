import os
import random

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from grades import average, passed

APP_VERSION = os.getenv("APP_VERSION", "dev")
ERROR_RATE = float(os.getenv("ERROR_RATE", "0"))  # for chaos drills, later

app = FastAPI(title="grades-api")


class Grades(BaseModel):
    grades: list[float]


@app.get("/health")
def health():
    return {"status": "ok", "version": APP_VERSION}


@app.post("/average")
def grade_average(req: Grades):
    if random.random() < ERROR_RATE:
        raise HTTPException(status_code=500, detail="injected failure")
    if len(req.grades) == 0:
        raise HTTPException(status_code=422, detail="expected grades")
    avg = average(req.grades)
    return {"average": avg, "passed": passed(avg), "version": APP_VERSION}
