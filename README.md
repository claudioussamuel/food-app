# FooduApp

Foodu - Food Delivery App built with Flutter

## Features

- 🍕 Food ordering and delivery
- 📍 Location-based services
- 🛒 Shopping cart functionality
- 💳 Payment integration
- 📱 Cross-platform (iOS & Android)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase project setup
- Google Maps API key (for location features)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. **Important**: Set up environment variables by following the instructions in [ENV_SETUP.md](ENV_SETUP.md)

4. Run the app:
   ```bash
   flutter run
   ```

## Environment Setup

This app requires environment variables for full functionality. Please see [ENV_SETUP.md](ENV_SETUP.md) for detailed setup instructions.

**Quick Setup:**
1. Create a `.env` file in the project root
2. Add your Google API key: `GOOGLE_API_KEY=your_api_key_here`
3. Restart the app

## Project Structure

```
lib/
├── features/          # Feature-based modules
├── common/           # Shared widgets and utilities
├── data/             # Data layer (repositories, services)
├── utils/            # Helper functions and constants
└── main.dart         # App entry point
```

## Technologies Used

- **Flutter** - UI framework
- **GetX** - State management
- **Firebase** - Backend services
- **Google Maps** - Location services
- **Get Storage** - Local storage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
