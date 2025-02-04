Here's the formatted version ready to copy-paste into your README.md file:

# BookSwipe - A Book Discovery App
A Flutter application that helps users discover books through a Tinder-like swiping interface. Users can create accounts, swipe through books, and save their preferences.

## Setup Requirements

### Prerequisites
- Flutter (v3.0.0 or higher)
- Node.js (v14.0.0 or higher)
- PostgreSQL (v12.0 or higher)
- npm (v6.0.0 or higher)

### Project Creation
```bash
# Create Flutter project in current directory
flutter create .

# Get dependencies
flutter pub get
```

### Database Setup
1. Install PostgreSQL
2. Create database named "BinderDBTest"
3. Run the provided SQL scripts to create tables and insert sample data

### Server Setup
```bash
# Install dependencies
npm install express pg cors jsonwebtoken

# Start the server
node server.js
```

### Flutter App Setup
```bash
# Install dependencies
flutter pub get
```

**Important**: Add Internet permission to `android/app/src/main/AndroidManifest.xml` right after the opening `<manifest>` tag:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application
        ...
```

Update the server IP address in `lib/services/api_service.dart` to match your local network.

## Project Structure
```
lib/
├── controllers/    # Business logic
├── models/         # Data models
├── screens/        # UI screens
├── services/       # API and auth services
└── widgets/        # Reusable widgets
```

## Features
- User authentication (login/signup)
- Book swiping interface with animations
- Detailed book information display
- Like/Dislike functionality
- User preference management
- Reading history tracking

## Architecture
The app follows MVC (Model-View-Controller) architecture:
- Models: Book and user data structures
- Views: Flutter widgets and screens
- Controllers: Business logic and state management

## API Endpoints
- POST /login - User authentication
- POST /signup - User registration
- GET /books - Fetch book recommendations
- POST /user/:id/preferences - Update user preferences

## Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test
```

## Troubleshooting
Common issues and solutions:
1. Network Connection Issues
   - Verify server IP address in api_service.dart
   - Check network permissions
2. Database Connection
   - Verify PostgreSQL connection string
   - Check database credentials

## Contributing
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License
This project is licensed under the MIT License - see the LICENSE file for details

## Screenshots
[Add screenshots/GIF demo of the app]
