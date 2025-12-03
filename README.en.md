# 🌦️ Cosmic Weather — Flutter App  
[🇮🇹 Italian Version](README.md)

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-orange)

A modern Flutter application that displays current weather conditions based on the user’s GPS position or by searching for a city.  
Includes animations, smooth loading, modular structure, and an advanced backend security system for protected asset delivery.

---

# 🚀 Main Features

- 📍 Weather via geolocation  
- 🏙️ Weather via city search  
- ✨ Animated intro screen  
- 🌌 Animated WebP planet served by a secure backend  
- 🔐 HMAC-based API authentication (demo mode in public repository)  
- 📱 Multi-platform support: Android, iOS, Web, Desktop  
- 📁 Scalable architecture: Models / Providers / Services / Widgets  

---

# 📸 App Preview

Intro screen:  
![App Demo](assets/screenshots/demo_resize.gif)

---

# 📦 Installation & Startup

Requires Flutter installed:  
👉 https://docs.flutter.dev/get-started/install

## 1️⃣ Clone the project

```sh
git clone https://github.com/dariosantamaria/weather_project_1.git
cd weather_project_1
```

---

# 🔑 `.env.demo` Configuration

The DEMO configuration is **already included**.

Required file: **assets/.env.demo**

Insert:

```ini
OPENWEATHER_API_KEY=YOUR_API_KEY

# Demo credentials (safe for public use)
API_BASE_URL=https://api.dariosantamaria.it
PLANET_DEVICE_ID=demo-device
PLANET_CLIENT_SECRET=4c7e2f8fa8d9344d07bc2f713ac98be5d7a52baf01c3c4174e9ddca97c080f69
```

🔐 **Important Note:**  
Your OpenWeather API Key is *personal* and should never be publicly shared.

---

# 📁 Configure `pubspec.yaml`

Make sure the `.env.demo` file is included:

```yaml
flutter:
  assets:
    - assets/.env.demo
```

---
# 📁 RUN the DEMO

Make sure your .env.demo file is ready, select your Android device, and run:

```sh
flutter run --dart-define=ENV=DEMO
```
### ⚠️ Platform notice

This project has been fully tested on Android devices.
Support for iOS, Web, and Desktop is planned, but not yet validated.

---

# 🛰️ DEMO Mode — Planet System

This app uses an **advanced HMAC security system** to protect private assets such as animated WebP sprites.  
Since the repository is public, **DEMO MODE** is enabled, allowing anyone to run the app without access to real private assets.

### ✔️ How it works

When a user clones the project, `.env.demo` contains **demo credentials**:

- `PLANET_DEVICE_ID=demo-device`  
- `PLANET_CLIENT_SECRET=4c7e2f8fa8d9344d07bc2f713ac98be5d7a52baf01c3c4174e9ddca97c080f69`  

These credentials allow:

- ✔️ downloading the **demo WebP planet**  
- ✔️ running the app with no real secrets  
- ❌ no access to protected real assets  

This keeps the private sprite system and backend secure while remaining open-source.

---

# 🧪 Integration Tests — Security Suite 1–15

Cosmic Weather includes a full integration test suite validating:

- 🔐 HMAC authentication  
- 🔁 nonce handling  
- 🕒 timestamp verification & clock skew  
- 🚫 invalid signature handling (fake, malformed, wrong key)  
- 📉 rate limiting & flood protection  
- 🛰️ secure asset access to the Planet System  

The suite also works in **DEMO MODE**, using the credentials inside `.env.demo`.

### ▶️ Standard execution (Android / emulator / physical device)

```
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/auth_service_security_suite_1_15_DEMO_test.dart `
  -d <DEVICE_ID> `
  --dart-define=ENV_FILE=assets/.env.demo
```

### ▶️ Execution with log (Windows PowerShell)

(Saves full test output to a TXT file)

```
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/auth_service_security_suite_1_15_DEMO_test.dart `
  -d <DEVICE_ID> `
  --dart-define=ENV_FILE=assets/.env.demo `
  *>&1 | Tee-Object -FilePath .\security_suite_1_15_DEMO_log.txt
```

> ⚠️ **Important Note**  
> The integration test suite uses a DEMO backend that is secure and rate-limited.  
> It is meant for educational and local validation purposes, **not load testing**.  
>
> Running the suite repeatedly or reducing delays between requests  
> may trigger backend protections.  
>
> Please run tests responsibly. 🚀

### 🛠️ Backend Architecture (Technical Overview)

The backend powering Planet System & security features runs on a private Ubuntu server:

```
┌───────────────┐      ┌───────────────┐      ┌────────────────────────┐
│ Flutter App   │ ---> │   NGINX       │ ---> │  FastAPI (Python)      │
│ (HMAC-secured)│      │ Reverse Proxy │      │  + Nonce Engine        │
└───────────────┘      └───────────────┘      │  + Rate Limiter        │
                                              │  + Planet WebP Manager │
                                              └────────────────────────┘
```

Backend features include:

- 🔐 **HMAC authentication** with unique device IDs  
- 🔁 **Nonce + timestamp validation**  
- 🚫 **Flood & replay-attack prevention**  
- 📉 **API-level rate limiting**  
- 🌌 **Secure delivery of private WebP planet assets**

The backend source is **not included** in the public repository.  
📩 Contact me if you want more details or you're interested in backend collaboration.

---

# 📂 Project Structure

```
lib/
├── 📁 debug/                     🌙 Development-only utilities
│ ├── 📄 debug_raw_weather.dart
│ ├── 📄 performance_debug.dart
│ └── 📄 weather_debug.dart
│
├── 📁 models/                    ☁️ Data models
│ └── 📄 weather.dart
│
├── 📁 providers/                 🔧 State Management (Provider)
│ └── 📄 weather_provider.dart
│
├── 📁 screens/                   🖥️ Main screens
│ ├── 📄 home_screen.dart
│ ├── 📄 intro_screen.dart
│ └── 📄 weather_screen.dart
│
├── 📁 services/                  🔐 API & Security services
│ ├── 📄 auth_service.dart
│ ├── 📄 debug_signature.dart
│ ├── 📄 planet_service.dart
│ └── 📄 weather_service.dart
│
└── 📁 widgets/                   🎨 Reusable UI components
  ├── 📄 animated_planet.dart
  └── 📄 weather_card.dart

📄 main.dart                      🚀 App entry point
```

---

# 🧩 Roadmap

- 🌗 Light / Dark Theme  
- 📅 7-day forecast  
- 🎬 Additional animations  
- 🌍 IT/EN localization  
- 📱 Store publication  

---

# 🐛 Bugs & Feature Requests

Found a bug? Want to propose a new feature?

➡️ Open an **Issue**  
➡️ Or submit a **Pull Request**

Your contribution is greatly appreciated! 🤝

---

# 🧑‍💻 Author

**Dario Santamaria**  
🔗 https://www.linkedin.com/in/dario-santamaria-0a8b7911a/

---

# ⭐ Support the project

If you like the app, leave a **Star ⭐** on GitHub!
