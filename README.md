# Campus Assistant

A comprehensive multi-platform Flutter application designed to streamline university campus life. Campus Assistant connects students, teachers, and staff through a unified digital ecosystem.

## Features

### 🎓 Academic
- **Course Management** — Browse courses by semester, access chapters, notes, videos, books, and questions
- **Class Routine** — View weekly class schedules
- **Syllabus** — Full course syllabus reference
- **Teachers & Staff** — Directory with contact details and profiles
- **Students** — Browse by batch and department
- **CR (Class Representative)** — Information and contact

### 🤝 Community & Communication
- **Community** — Discussion board for campus-wide conversations
- **Inbox / Chat** — Real-time messaging with WebSocket support
- **Notifications** — Push and in-app notifications
- **Clubs & Organizations** — Browse and join campus clubs

### 🏛️ Campus Services
- **University Info** — Halls, location map, and general information
- **Departments** — Department-wise details
- **Transport Service** — Bus routes and schedules
- **Blood Bank** — Blood group directory
- **Emergency Contacts** — Quick access to important numbers
- **Alumni Network** — Connect with graduates

### 📚 Study Tools
- **Library** — Digital resource access
- **Research** — Research paper browsing
- **Bookmarks** — Save and organize content
- **Downloads** — Offline access to downloaded files
- **Resource Sharing** — Upload and share study materials

### 💳 Subscription & Payments
- **bKash Integration** — Secure payment processing for subscriptions
- **Subscription Plans** — Tiered access to premium features

### 👤 Profile
- Student profile management
- Edit personal information
- Dark/Light theme support

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter (Android, iOS, Web) |
| **State Management** | Riverpod |
| **Routing** | GoRouter |
| **Networking** | Dio, HTTP |
| **Real-time** | WebSocket |
| **Local Storage** | flutter_secure_storage, sqflite |
| **Environment** | flutter_dotenv |
| **Maps** | flutter_map (OpenStreetMap) |
| **Payments** | bKash API |
| **UI** | Material 3, Google Fonts, Lucide Icons, Skeletonizer |

## Getting Started

### Prerequisites

- Flutter SDK >=3.10.4
- Dart SDK >=3.10.4
- Android Studio / Xcode (for device builds)

### Installation

```bash
# Clone the repository
git clone https://github.com/sofolitltd/campusassistant.git
cd campusassistant

# Install dependencies
flutter pub get

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Run the app
flutter run
```

### Environment Variables

Create a `.env` file in the project root (see `.env.example`):

```env
BASE_URL=https://your-api-url/api/v1
API_KEY=your-api-key

# bKash Production Credentials
BKASH_PROD_USERNAME=your-username
BKASH_PROD_PASSWORD=your-password
BKASH_PROD_APP_KEY=your-app-key
BKASH_PROD_APP_SECRET=your-app-secret
```

## Project Structure

```
lib/
├── core/              # Shared infrastructure
│   ├── network/       # API client, endpoints
│   ├── providers/     # App-wide providers (theme, refresh)
│   ├── theme/         # Light/dark theme definitions
│   └── usecase/       # Use case base class
├── features/          # Feature modules
│   ├── auth/          # Authentication
│   ├── study/         # Courses, notes, resources
│   ├── home/          # Home page with sections
│   ├── inbox/         # Real-time chat
│   ├── community/     # Discussion board
│   ├── bkash/         # Payment integration
│   ├── ...            # 30+ feature modules
├── routes/            # GoRouter configuration
├── services/          # Firebase, etc.
├── utils/             # Constants, helpers
└── widgets/           # Shared widgets
```

## Development

```bash
# Analyze code
dart analyze

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web
```

## Architecture

The app follows a **feature-first** architecture with Riverpod for state management:

- **Data layer** — Repositories, data sources (API, local)
- **Domain layer** — Entities, use cases
- **Presentation layer** — Screens, widgets, providers

Each feature module is self-contained with its own providers, models, and screens.

## License

This project is proprietary software developed by **Sofolit Ltd**.

## Contact

- **Developer:** Md Asifuzzaman Reyad
- **Email:** campusassistantbd@gmail.com
- **Website:** [sofolit.vercel.app](https://sofolit.vercel.app)
- **Facebook Group:** [Campus Assistant BD](https://www.facebook.com/campusassistantbd)
- **YouTube:** [@campusassistantbd](https://www.youtube.com/@campusassistantbd)
