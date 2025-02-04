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
```bash
# Connect and create database
psql -U postgres
CREATE DATABASE "BinderDBTest";
\q

# Set up database structure and sample data
psql -U postgres -d BinderDBTest -f BinderDB.sql
psql -U postgres -d BinderDBTest -f BookInsertion.sql

# Optional: Reset database if needed
psql -U postgres -f reset_db.sql
```

### Server Setup
```bash
# Install dependencies
npm install express pg cors jsonwebtoken
# Start the server
node server.js
```

### Flutter App Setup
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Add Internet permission to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <manifest xmlns:android="http://schemas.android.com/apk/res/android">
       <uses-permission android:name="android.permission.INTERNET" />
       <application
           ...
   ```
3. Update server configuration in `lib/services/api_service.dart` to match your local network IP

## Project Structure
```
lib/
├── controllers/
│   ├── auth_controller.dart
│   ├── book_controller.dart
│   ├── landing_controller.dart
│   └── profile_controller.dart
├── main.dart
├── models/
│   └── book.dart
├── screens
│   ├── book_swipe_page.dart
│   ├── landing_page.dart
│   ├── login_page.dart
│   ├── main_screen.dart
│   ├── profile_page.dart
│   └── signup_page.dart
├── services
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── token_storage.dart
└── widgets
    ├── loading_button.dart
    └── login_form.dart
```

## Features
- User authentication (login/signup)
- Book swiping interface with animations
- Detailed book information display
- Like/Dislike functionality
- User preference management
- Reading history tracking
- Offline mode support
- Dark/Light theme toggle
- Reading list management

## Architecture
The app follows MVC (Model-View-Controller) architecture:
- Models: Book and user data structures
- Views: Flutter widgets and screens
- Controllers: Business logic and state management

## API Endpoints
### Authentication
- POST /api/login - User authentication
- POST /api/signup - User registration
- POST /api/logout - User logout
- GET /api/user/verify - Token verification

### Books
- GET /api/books - Fetch book recommendations
- GET /api/books/:id - Get book details
- GET /api/books/recommended - Get personalized recommendations

### User Preferences
- GET /api/user/:id/preferences - Get user preferences
- POST /api/user/:id/preferences - Update user preferences
- DELETE /api/user/:id/preferences - Reset preferences

## Troubleshooting
Common issues and solutions:

### Network Connection Issues
- Verify server IP address in api_service.dart
- Check network permissions
- Ensure firewall allows Flutter app connections

### Database Connection
- Verify PostgreSQL connection string
- Check database credentials
- Ensure database service is running
- Verify port availability (default: 5432)

## Contributing
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License
This project is licensed under the MIT License - see the LICENSE file for details

## Screenshots
![Media](https://github.com/user-attachments/assets/d239b0ed-8205-42d7-91a9-ca50e6b04e4f)![Media (1)](https://github.com/user-attachments/assets/f58cff21-1bfa-4fed-a1ca-ceb05c29d736)


