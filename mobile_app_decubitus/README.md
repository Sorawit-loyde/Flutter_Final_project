# mobile_app_decubitus

A new Flutter project.

## Thesis Project for KMITL CE67-43

This project is part of the thesis for the Computer Engineering program at King Mongkut's Institute of Technology Ladkrabang (KMITL), class CE67-43.

### Features

- User authentication and profile management
- Real-time monitoring of patient conditions
- Image upload and analysis for wound assessment
- Treatment plan suggestions based on wound severity
- Notifications and reminders for follow-up care

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development, macOS only)
- [Visual Studio Code](https://code.visualstudio.com/) (optional, for code editing)

### Installation

1. **Clone the repository**:
   ```sh
   git clone https://github.com/Final-Project-Thailand-telemedicine/Mobile-Application.git
   cd mobile_app_decubitus
   ```

2. **Install dependencies**:
   ```sh
   flutter pub get
   ```

3. **Run the application**:
   - For Android:
     ```sh
     flutter run
     ```
   - For iOS (macOS only):
     ```sh
     flutter run
     ```

### Configuration

The application uses a configuration file to manage various settings. The configuration file is located at `lib/config/config.dart`. You can update the configuration settings as needed.

Example configuration:
```dart
class Custom_Config {
  static const String Image_URL = 'https://example.com/images';
  // Add other configuration settings here
}
```

### Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

