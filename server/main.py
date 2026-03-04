"""
Modern Weather App - Python API Proxy Server
Securely proxies requests to OpenWeatherMap and Unsplash APIs.

Usage:
    1. Activate the venv:  .venv\Scripts\activate
    2. Install deps:       pip install -r server/requirements.txt
    3. Set your API keys in .env file
    4. Run:                cd server && python -m uvicorn main:app --reload --port 8000
"""

import os
from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
import httpx

# Load environment variables
from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

OPENWEATHER_KEY = os.getenv('OPENWEATHER_API_KEY', 'YOUR_KEY_HERE')
UNSPLASH_KEY = os.getenv('UNSPLASH_ACCESS_KEY', 'YOUR_KEY_HERE')

app = FastAPI(title="Weather Proxy", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET"],
    allow_headers=["*"],
)

OWM_BASE = "https://api.openweathermap.org/data/2.5"
UNSPLASH_BASE = "https://api.unsplash.com"


@app.get("/weather")
async def get_weather(
    lat: float = Query(...),
    lon: float = Query(...),
    units: str = Query("metric"),
):
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{OWM_BASE}/weather",
            params={"lat": lat, "lon": lon, "units": units, "appid": OPENWEATHER_KEY},
        )
        return resp.json()


@app.get("/forecast")
async def get_forecast(
    lat: float = Query(...),
    lon: float = Query(...),
    units: str = Query("metric"),
):
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{OWM_BASE}/forecast",
            params={"lat": lat, "lon": lon, "units": units, "appid": OPENWEATHER_KEY},
        )
        return resp.json()


@app.get("/weather/city")
async def get_weather_by_city(
    q: str = Query(...),
    units: str = Query("metric"),
):
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{OWM_BASE}/weather",
            params={"q": q, "units": units, "appid": OPENWEATHER_KEY},
        )
        return resp.json()


@app.get("/city-image")
async def get_city_image(
    query: str = Query(...),
):
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"{UNSPLASH_BASE}/search/photos",
            params={
                "query": f"{query} city skyline",
                "per_page": 1,
                "orientation": "landscape",
                "client_id": UNSPLASH_KEY,
            },
        )
        return resp.json()


@app.get("/health")
async def health():
    return {"status": "ok", "service": "weather-proxy"}
