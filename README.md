# PokerRun Player — Player App

Version **1.0.0+25** · Flutter · Firebase

The player-side app for participating in Poker Run events. Find events, register, navigate stops, draw cards, and view results.

---

## Overview

PokerRun Player is used by **event participants** (riders). The companion organizer app is **PokerRun Network** (`pokerrunnetwork`). Both apps share the same Firebase backend.

---

## Features

### Finding & Joining Events
- Browse all available upcoming Poker Runs
- View event details: stops, fees, date, organizer, description
- Join with options: co-rider, change-card upgrade
- Co-rider pairing — link with a primary rider or bring a co-rider of your own
- Fee breakdown shown before joining (join fee + co-rider fee + change-card fee)

### Check-in & Approval
- After joining, players wait for organizer approval before starting
- **Show QR Code** — tap the QR icon on the schedule screen to display a personal QR code. The organizer scans it to instantly approve the player
- QR icon only appears while the player is unapproved; it disappears once approved
- Real-time approval status — the screen reflects organizer approval the moment it happens

### Running the Event
- **Schedule screen** — shows event date, starting point address, distance from current location, and a "To Starting Point" navigation button
- Player must be within the configured radius of the start to begin
- **Game screen** — shows current stop, navigation to next stop, and card reveal when within range
- Route is personalized per player (organizer can assign different stop sequences)
- **Change card** — if the change-card option was purchased, player can swap one drawn card

### Results
- **All Hands** page — view all submitted hands with rankings
- **Completed Runs** — browse past events and final results

### Other
- Multiple active runs supported — switch between them via dropdown
- In-app ads via Easy AdMob
- FAQ and settings pages

---

## Tech Stack

| Layer | Package |
|---|---|
| Framework | Flutter 3.x |
| State management | GetX |
| Backend | Cloud Firestore, Firebase Auth, Firebase Remote Config |
| QR display | qr_flutter ^4.1.0 |
| Maps | map_launcher ^4.4.2 |
| Location | location ^8.0.1 |
| HTTP | dio |
| Fonts | google_fonts |
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
│   ├── gamePlayerModel.dart    # GamePlayerModel — participant record (searchParameter includes real name)
│   ├── stops.dart              # StopsModel — individual stop
│   ├── userModel.dart
│   ├── gameData.dart
│   └── transaction.dart
├── services/
│   ├── firestoreServices.dart  # All Firestore read/write operations
│   └── remortConfig.dart       # Firebase Remote Config loader
└── page/home/
    ├── home_page.dart           # Main dashboard
    ├── active_poker_run.dart    # Active run dropdown/switcher
    ├── find_poker.dart          # Browse and join events
    ├── poker_view.dart          # Event detail and join flow
    ├── schedule_poker.dart      # Pre-start screen with QR code entry point
    ├── player_qr_screen.dart    # Full-screen QR code display for check-in
    ├── game_view.dart           # In-run navigation and card drawing
    ├── stop_view.dart           # Individual stop check-in
    ├── participant_list.dart    # View other participants
    ├── all_hands_page.dart      # All submitted hands with rankings
    ├── completed_pokr.dart      # Past completed runs
    ├── route_map_view.dart      # Map of the full route
    ├── faq_page.dart
    └── setting_page_network.dart
```

---

## Firebase Collections

Shares the same Firestore database as PokerRun Network.

| Collection | Purpose |
|---|---|
| `events` | Event documents |
| `events/{id}/participants` | Player sub-collection — player reads and writes their own document |
| `userProfiles` | Player profile |

### Participant document — fields written by this app

| Field | Type | Notes |
|---|---|---|
| `approved` | bool | Set by organizer; player reads this to unlock start |
| `searchParameter` | string[] | Prefix tokens for `roadName` AND `userName` (word-split for first/last name search) |
| `currentStop` | int | Updated as player progresses through stops |
| `cards` | int[] | Card indexes drawn — appended at each stop |
| `routeSequence` | int[] | Player's assigned stop order |

---

## QR Check-in Flow

1. Player joins an event and waits on the **Schedule screen**
2. While unapproved, a **QR icon** appears in the top-right app bar
3. Player taps it → full-screen QR code is displayed with road name and event name
4. Player shows the screen to the organizer
5. Organizer scans using PokerRun Network → player's `approved` flag is set to `true`
6. The real-time stream on the schedule screen detects the change; the QR icon disappears and the **Start** button becomes active

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
| `miles` | Number | distance radius to start a run |

---

## Permissions

### iOS
- **Camera** — QR display does not require camera; camera used for profile photo upload
- **Location** — distance checks to starting point and stops
- **Photo Library** — profile image upload

### Android
- Location and internet permissions in `AndroidManifest.xml`

---

## Related App

**PokerRun Network** (`pokerrunnetwork`) — companion app used by organizers to create events, authorize players, track progress, and declare winners.
