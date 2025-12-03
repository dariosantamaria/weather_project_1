# 🌦️ Cosmic Weather — Flutter App  
[🇬🇧 English Version](README.en.md)

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-orange)

Una moderna app Flutter che mostra le condizioni meteo correnti sulla base della posizione GPS dell’utente o tramite ricerca città.  
Include animazioni, caricamenti fluidi, struttura modulare e un sistema avanzato di sicurezza backend per la gestione di asset protetti.

---

# 🚀 Funzionalità Principali

- 📍 Meteo tramite geolocalizzazione  
- 🏙️ Meteo tramite ricerca città  
- ✨ Schermata introduttiva animata  
- 🌌 Pianeta animato (WebP) fornito da backend sicuro  
- 🔐 Sistema HMAC per autenticazione API (in modalità demo nel repository pubblico)  
- 📱 Supporto multipiattaforma: Android, iOS, Web, Desktop  
- 📁 Architettura scalabile: Models / Providers / Services / Widgets  

---

# 📸 Anteprima App

Schermata iniziale:  
![App Demo](assets/screenshots/demo_resize.gif)

---

# 📦 Installazione & Avvio

Richiede Flutter installato:  
👉 https://docs.flutter.dev/get-started/install

## 1️⃣ Clona il progetto

```sh
git clone https://github.com/dariosantamaria/weather_project_1.git
cd weather_project_1
```

---

# 🔑 Configurazione `.env.demo`

La configurazione DEMO è **già pronta**.

File richiesto: **assets/.env.demo**

Inserisci:

```ini
OPENWEATHER_API_KEY=LA_TUA_API_KEY

# Demo credentials (sicure da condividere pubblicamente)
API_BASE_URL=https://api.dariosantamaria.it
PLANET_DEVICE_ID=demo-device
PLANET_CLIENT_SECRET=4c7e2f8fa8d9344d07bc2f713ac98be5d7a52baf01c3c4174e9ddca97c080f69
```

🔐 **Nota importante:**  
La tua API Key OpenWeather è *personale* e non va mai condivisa pubblicamente.

---

# 📁 Configura `pubspec.yaml`

Assicurati che il file `.env.demo` sia incluso:

```yaml
flutter:
  assets:
    - assets/.env.demo
```

---
# 📁 AVVIA la DEMO

Assicurati che il file `.env.demo` sia quindi pronto, seleziona il tuo dispositivo Android e inserisci il comando:

```sh
flutter run --dart-define=ENV=DEMO
```
### ⚠️ Avviso di compatibilità piattaforme

Questo progetto è stato testato completamente su dispositivi Android.
Il supporto per iOS, Web e Desktop è previsto, ma non ancora validato.

---

# 🛰️ Modalità DEMO — Planet System

Questa app utilizza un **sistema avanzato di sicurezza HMAC** per proteggere asset privati come sprite WebP animati.  
Poiché il repository è pubblico, è attiva la **DEMO MODE**, che permette a chiunque di eseguire l'app senza accesso ai veri asset privati.

### ✔️ Come funziona

Quando l’utente clona il progetto, il file `.env.demo` contiene **credenziali demo**:

- `PLANET_DEVICE_ID=demo-device`  
- `PLANET_CLIENT_SECRET=4c7e2f8fa8d9344d07bc2f713ac98be5d7a52baf01c3c4174e9ddca97c080f69`  

Queste credenziali funzionano solo per:
- ✔️ scaricare la **versione demo del pianeta WebP**  
- ✔️ testare l’app senza chiavi reali  
- ❌ non consentono accesso agli asset protetti reali  

Questo protegge la versione privata degli sprite e del backend mantenendo il repository open-source.

## 🧪 Integration Tests — Security Suite 1–15

Cosmic Weather include una suite avanzata di test di integrazione che verifica:

- 🔐 autenticazione HMAC  
- 🔁 gestione del nonce  
- 🕒 clock skew e timestamp validation  
- 🚫 signature validation (fake, malformed, wrong key)  
- 📉 rate-limiting e flood protection  
- 🛰️ accesso sicuro agli asset del Planet System  

La suite funziona anche in **DEMO MODE**, usando le credenziali demo già incluse in `.env.demo`.

#### ▶️ Esecuzione standard (Android / emulator / device fisico)
(usa .env.demo come fallback DEMO universale)
```
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/auth_service_security_suite_1_15_DEMO_test.dart `
  -d <DEVICE_ID> `
  --dart-define=ENV_FILE=assets/.env.demo
```

#### ▶️ Esecuzione con log (Windows PowerShell)
(utile per salvare l’intera suite in un file TXT)
```
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/auth_service_security_suite_1_15_DEMO_test.dart `
  -d <DEVICE_ID> `
  --dart-define=ENV_FILE=assets/.env.demo `
  *>&1 | Tee-Object -FilePath .\security_suite_1_15_DEMO_log.txt
```

> ⚠️ **Nota importante sui test**
>
> La suite di integration test utilizza un backend **DEMO**, protetto e rate-limited.  
> È pensata per scopi didattici e di verifica locale, **non per test di carico**.
>
> Eseguire ripetutamente la suite o ridurre artificialmente i tempi tra le richieste
> potrebbe attivare i limiti di sicurezza.
>
> Per favore esegui i test in modo responsabile. 🚀

### 🛠️ Architettura Backend (Panoramica Tecnica)

Il backend che gestisce il Planet System e le funzionalità di sicurezza gira su un server Ubuntu privato:

```
┌───────────────┐      ┌───────────────┐      ┌────────────────────────┐
│ Flutter App   │ ---> │   NGINX       │ ---> │  FastAPI (Python)      │
│ (HMAC-secured)│      │ Reverse Proxy │      │  + Nonce Engine        │
└───────────────┘      └───────────────┘      │  + Rate Limiter        │
                                              │  + Planet WebP Manager │
                                              └────────────────────────┘
```

Funzionalità principali del backend:

- 🔐 **Autenticazione HMAC** con device ID univoci  
- 🔁 **Validazione di nonce + timestamp**  
- 🚫 **Protezione da flood e replay attack**  
- 📉 **Rate limiting a livello API**  
- 🌌 **Distribuzione sicura degli asset WebP del pianeta**

Il codice sorgente del backend **non è incluso** nel repository pubblico.  
📩 Contattami se vuoi maggiori dettagli o se sei interessato a collaborare sul backend.

---

## 📂 Struttura del Progetto

```
lib/
├── 📁 debug/                     🌙 Utility di Debug (solo sviluppo)
│ ├── 📄 debug_raw_weather.dart
│ ├── 📄 performance_debug.dart
│ └── 📄 weather_debug.dart
│
├── 📁 models/                    ☁️ Modelli dati
│ └── 📄 weather.dart
│
├── 📁 providers/                 🔧 State Management (Provider)
│ └── 📄 weather_provider.dart
│
├── 📁 screens/                   🖥️ Schermate principali
│ ├── 📄 home_screen.dart
│ ├── 📄 intro_screen.dart
│ └── 📄 weather_screen.dart
│
├── 📁 services/                  🔐 Servizi API & Sicurezza
│ ├── 📄 auth_service.dart
│ ├── 📄 debug_signature.dart
│ ├── 📄 planet_service.dart
│ └── 📄 weather_service.dart
│
└── 📁 widgets/                   🎨 Componenti UI riutilizzabili
  ├── 📄 animated_planet.dart
  └── 📄 weather_card.dart

📄 main.dart                      🚀 Entrypoint dell’app
```

---

# 🧩 Roadmap

- 🌗 Tema Light / Dark  
- 📅 Previsioni 7 giorni  
- 🎬 Animazioni extra  
- 🌍 Localizzazione IT/EN  
- 📱 Pubblicazione negli store  

---

# 🐛 Bug & Richieste Feature

Hai trovato un bug? Vuoi proporre una nuova funzionalità?

➡️ Apri una **Issue**  
➡️ Oppure invia una **Pull Request**

Il tuo contributo è molto apprezzato! 🤝

---

# 🧑‍💻 Autore

**Dario Santamaria**  
🔗 https://www.linkedin.com/in/dario-santamaria-0a8b7911a/

---

# ⭐ Supporta il progetto

Se l’app ti piace, lascia una **Star ⭐** su GitHub!
