# 🌦️ Modern Weather App

> *Because checking the weather shouldn't feel like reading a spreadsheet.*

A **stupidly beautiful** Flutter weather app that makes you *want* to check the forecast. Rain or shine, this app looks gorgeous — and yes, it even makes overcast Tuesdays feel aesthetic.

---

## ✨ What Makes This Different

This isn't your grandma's weather app. We went full overkill:

| Feature | Boring Version | Our Version |
|---------|---------------|-------------|
| Weather display | "22°C, Cloudy" |  Dynamic gradients that shift with conditions + animated rain/snow/star particles |
| City background | A grey rectangle |  Real Unsplash photography of the city skyline |
| Loading state | A spinning circle |  Shimmer skeleton loading that looks _chef's kiss_ |
| Dark mode | "Oh yeah we have that" |  Deep navy glassmorphism that would make Apple jealous |
| Location | "Enter your city" |  GPS auto-detection on launch. We find *you*. |

---

## 🎬 Features at a Glance

-  **Real-time weather** — Current temp, feels like, highs & lows
-  **5-day forecast** — With temperature range bars and precipitation %
-  **Hourly forecast** — Scrollable 24hr breakdown
-  **City backgrounds** — Fetched from Unsplash because your weather deserves a wallpaper
-  **Animated particles** — Rain drops, snowflakes, sun motes, twinkling stars, cloud puffs
-  **Glassmorphism UI** — Frosted glass cards with backdrop blur
-  **City search** — 12 popular cities + recent history
-  **Dark / Light mode** — Toggle in-app, defaults to dark (as it should)
-  **Geolocation** — Auto-detects your city on first launch
- °C/°F **Unit toggle** — For our friends across the pond 🇺🇸🇬🇧
-  **Weather details** — Wind, humidity, pressure, visibility, sunrise/sunset

---

##  Tech Stack

```
Flutter        →  Cross-platform UI framework
Dart              →  The language that makes Flutter flutter
Provider          →  State management (simple & clean)
OpenWeatherMap    →  Weather data API (free tier)
Unsplash API      →  Beautiful city photography
Geolocator        →  GPS location detection
Google Fonts      →  Outfit + Inter (premium typography)
CustomPainter     →  Hand-crafted weather particle animations
FastAPI (Python)  →  Optional proxy server for API key security
```

---

##  Project Structure

```
lib/
├── main.dart                     # Where the magic begins 
├── config/constants.dart         # API keys & endpoints
├── models/                       # Weather, Forecast, CityImage data classes
├── services/                     # API call logic (weather, images, GPS)
├── providers/                    # State management brains 
├── screens/                      # Splash → Home → Search
│   ├── splash_screen.dart        # Animated logo + location detection
│   ├── home_screen.dart          # The main show 
│   └── search_screen.dart        # Find any city on Earth
├── widgets/                      # Reusable UI components
│   ├── animated_background.dart  # Rain/snow/stars particle engine 
│   ├── glass_card.dart           # Frosted glass = instant premium feel
│   ├── weather_card.dart         # Big temp display + conditions
│   ├── hourly_forecast.dart      # Scrollable hourly cards
│   ├── forecast_card.dart        # 5-day breakdown with temp bars
│   └── shimmer_loading.dart      # Skeleton loading states
└── theme/                        # Dark & light theme definitions
    ├── app_theme.dart            # ThemeData for both modes
    └── app_colors.dart           #  Weather → gradient color mapping

server/                           #  Optional Python proxy
├── main.py                       # FastAPI server
└── requirements.txt              # pip dependencies
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- An Android device/emulator
- 2 free API keys (takes 2 minutes)

### 1. Clone & Install

```bash
git clone <your-repo-url>
cd "Modern Weather App"
flutter pub get
```

### 2. Add Your API Keys

Open `lib/config/constants.dart` and replace the placeholders:

```dart
static const String weatherApiKey = 'YOUR_OPENWEATHER_API_KEY';
static const String unsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';
```

🔑 Get free keys:
- **OpenWeatherMap** → [openweathermap.org/api](https://openweathermap.org/api) (sign up, free tier, 60 calls/min)
- **Unsplash** → [unsplash.com/developers](https://unsplash.com/developers) (register an app)

### 3. Run It

```bash
flutter run
```

Grant location permission when prompted, and watch the magic happen. ✨

---

## 🐍 Python Proxy Server (Optional)

Don't want API keys baked into your APK? Use the included FastAPI proxy:

```bash
# Activate the Python venv
.venv\Scripts\activate

# Install proxy dependencies
pip install -r server/requirements.txt

# Add your keys to .env file
# OPENWEATHER_API_KEY=your_key
# UNSPLASH_ACCESS_KEY=your_key

# Run the proxy
cd server
python -m uvicorn main:app --reload --port 8000
```

Then point your Flutter app to `http://localhost:8000` instead of the APIs directly.

---

## 🎨 Design Philosophy

> *We don't do boring.*

Every pixel of this app was designed to make weather data feel **alive**:

- **Dynamic gradients** shift based on weather conditions AND time of day
- **Particle animations** are rendered via `CustomPainter` — no heavy Lottie files
- **Glassmorphism cards** use real `BackdropFilter` blur, not fake overlays
- **Typography** uses Google Fonts (Outfit for headers, Inter for body) — no system defaults
- **Color palette** is carefully curated — no generic reds, blues, or greens in sight

---

## 📸 Screenshots

> *Coming soon — run the app and see for yourself!*

---

## 📝 License

Do whatever you want with it. Seriously. Just don't blame us if you become obsessed with checking the weather.

---

<p align="center">
  Made with 🧡 and an unhealthy amount of <code>BoxDecoration</code>
</p>
