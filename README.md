# PokerRun Network — Organizer App

Version **1.0.2+28** · Flutter · Firebase

The organizer-side app for managing Poker Run events. Create events, manage stops and routes, authorize participants, track live player progress, and declare winners.

---

## Overview

PokerRun Network is used exclusively by **event organizers and co-managers**. The companion player app is **PokerRun Player** (`pokerrunplayer`). Both apps share the same Firebase backend.

---

## Features

### Event Management
- Create and edit Poker Run events with name, date, join fee, co-rider fee, and change-card fee
- Define up to 7 stops with names, addresses, and GPS coordinates
- Set a custom route with stop ordering
- Copy an existing event to reuse settings for a new run
- Cancel or delete events with confirmation
- Complete an event — auto-fills missing cards, computes the winner, and publishes results

### Participant Authorization
- View all registered players with their payment amount due
- One-tap approve or deny each player
- **Search** by road name or real name (first or last name prefix search supported)
- Unapproved players sort to the top when searching
- **QR Code scan** — tap the scan icon in the app bar, scan a player's QR code from the Player app, and instantly approve them. Shows road name, success/failure, and already-approved states. Torch toggle included
- **Auto-Approve toggle** — approves all current unapproved participants in a batch and auto-approves all future joiners, even when the app is offline

### Live Progress Tracking
- See every active player's current stop in real time
- Stop labels resolved from each player's personal route sequence

### Co-Manager Management
- Add co-managers by name and email
- Co-managers can access all event management screens
- Remove individual co-managers or remove yourself from a co-managed event

### Other
- Sponsor and affiliate management
- In-app ads via Easy AdMob
- Remote config flags (`needApproval`, `autoFillCards`) controlled via Firebase Remote Config

---

## Tech Stack

| Layer | Package |
|---|---|
| Framework | Flutter 3.x |
| State management | GetX |
| Backend | Cloud Firestore, Firebase Auth, Firebase Remote Config |
| Pagination | paginate_firestore |
| QR scanning | mobile_scanner ^7.0.1 |
| Maps | place_picker, map_launcher |
| Location | location ^8.0.1 |
| Image upload | image_picker |
| Ads | easy_admob_ads_flutter |
| UI | responsive_sizer, remixicon, shimmer_animation |

---

## Project Structure

```
lib/
├── config/
│   ├── colors.dart             # App color constants
│   ├── global.dart             # Global state (currentUser, currentGame, etc.)
│   ├── supportFunctions.dart   # generateArray, calculateDistance, toast, etc.
│   └── random.dart
├── models/
│   ├── event.dart              # EventModel — full event schema
│   ├── gamePlayerModel.dart    # GamePlayerModel — participant record
│   ├── stops.dart              # StopsModel — individual stop
│   ├── userModel.dart
│   ├── gameData.dart
│   ├── analysis.dart
│   └── transaction.dart
├── services/
│   ├── firestoreServices.dart  # All Firestore read/write operations
│   └── remortConfig.dart       # Firebase Remote Config loader
└── page/home/
    ├── home_page.dart           # Dashboard / event list
    ├── pokerrun_list.dart       # Organizer's event list
    ├── manager_pokerRun.dart    # Per-event management menu
    ├── create_poker.dart        # Create / edit event form
    ├── partner_list.dart        # Authorize participants + QR scan entry point
    ├── qr_scanner_screen.dart   # Camera QR scanner for player approval
    ├── co_manager.dart          # Co-manager list, add/remove
    ├── poker_Stops.dart         # Stop configuration
    ├── poker_route.dart         # Route ordering
    ├── route_map_view.dart      # Map view of the route
    ├── poker_Sponsers.dart      # Sponsor management
    ├── affilate_menu.dart
    ├── faq_page.dart
    └── setting_page.dart
```

---

## Firebase Collections

| Collection | Purpose |
|---|---|
| `events` | One document per poker run |
| `events/{id}/participants` | Player sub-collection per event |
| `userProfiles` | Organizer and player profiles |
| `transactions` | Payment records |
| `admin/info` | Help line, support email, website |
| `admin/stats` | Global counters |

### Participant document — key fields

| Field | Type | Notes |
|---|---|---|
| `approved` | bool | Organizer has authorized this player |
| `roadName` | string | Player's biker alias |
| `userName` | string | Player's real name |
| `searchParameter` | string[] | Prefix tokens for road name and real name (word-split) |
| `currentStop` | int | 0 = not started, 1+ = in progress |
| `routeSequence` | int[] | Stop order for this player |
| `cards` | int[] | Card indexes drawn at each stop |
| `rankValue` | int | 0 = not finished, >0 = finishing position |

---

## QR Approval Flow

1. Organizer opens **Authorize Participants** and taps the **QR scan icon** (top-right of app bar)
2. Camera opens with a scan frame overlay and optional torch toggle
3. Player opens PokerRun Player → schedule screen → taps the **QR icon** in the app bar
4. Organizer scans the player's QR code
5. App validates the event ID, fetches the participant, and sets `approved = true`
6. Result dialog: approved / already approved / wrong event / not found
7. Tap **Scan Next** to scan the next player immediately

QR payload format: `userId|eventId`

---

## Getting Started

### Prerequisites
- Flutter SDK (see `.fvmrc` for the pinned FVM version)
- Firebase project with Firestore, Auth, and Remote Config enabled
- `google-services.json` in `android/app/`
- `GoogleService-Info.plist` in `ios/Runner/`

### Setup

```bash
# Use the pinned Flutter version via FVM
fvm install && fvm use

# Install dependencies
fvm flutter pub get

# Run
fvm flutter run
```

### Firebase Remote Config keys

| Key | Type | Default |
|---|---|---|
| `needApproval` | Boolean | `true` |
| `autoFillCards` | Boolean | `false` |

---

## Permissions

### iOS
- **Camera** — QR code scanning
- **Location** — proximity checks and map features
- **Photo Library** — profile image upload

### Android
- Camera, location, and internet permissions in `AndroidManifest.xml`

---

## Related App

**PokerRun Player** (`pokerrunplayer`) — companion app used by participants to join events, navigate stops, draw cards, and view results.
