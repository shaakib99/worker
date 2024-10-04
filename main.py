from fastapi import FastAPI, Response
from dotenv import load_dotenv
from prometheus_service.scrape_data import generate_data

async def lifespan(app):
    load_dotenv()
    yield

app = FastAPI(lifespan=lifespan)

routers = []

for router in routers:
    app.include_router(router)

@app.get("/metrics")
async def metrics():
    return Response(content=generate_data(), media_type="text/plain")