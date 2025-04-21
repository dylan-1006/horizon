# Horizon - Anxiety Monitoring App

Horizon is a mobile application designed to help users monitor and manage their anxiety levels using Fitbit wearable device data. The app uses advanced machine learning algorithms to analyze physiological data and identify potential anxiety patterns, helping users understand their mental health better.

## Features

- **Fitbit Integration**: Connect your Fitbit device to track physiological data that can indicate anxiety patterns
- **Anxiety Monitoring**: View your anxiety levels over time with intuitive charts and visualizations
- **Personalized Insights**: Get personalized insights based on your data patterns
- **Notification Alerts**: Receive notifications when potential anxiety episodes are detected
- **Privacy-Focused**: Your data is protected with industry-standard encryption protocols
- **User-Friendly Interface**: Clean, intuitive design for a seamless user experience

## Download

[![Download APK](https://img.shields.io/github/v/release/dylan-1006/horizon?color=blue&label=Download&logo=android)](https://github.com/dylan-1006/horizon/releases/latest)

You can download the latest APK file directly from our [GitHub Releases](https://github.com/dylan-1006/horizon/releases/latest) page.

## Installation Guide

### Requirements

- Android device running Android 5.0 (Lollipop) or higher
- Active internet connection
- Fitbit account and compatible Fitbit device (optional for full functionality)

### Installation Steps

1. **Install on Android**

   - Download the APK from the [Releases page](https://github.com/dylan-1006/horizon/releases/latest)
   - Enable "Install from Unknown Sources" in your device settings if not already enabled
   - Open the downloaded APK file and follow the installation prompts
   - Grant necessary permissions when prompted during first launch

2. **Test Account**

   - For testing purposes, you can use the following credentials:
     - Email: test@gmail.com
     - Password: 12345678

3. **Connect Your Fitbit** (Optional)
   - Go to Settings > FitBit Health
   - Follow the authorization steps to connect your Fitbit account
   - Allow the requested permissions to enable full functionality

## Using the App

1. **Sign In / Register**

   - Sign in with your credentials or create a new account
   - You can sign in with Google or email/password

2. **Dashboard**

   - View your anxiety levels and trends
   - Access quick relaxation exercises

3. **Settings**

   - Connect/disconnect your Fitbit device
   - Configure notification preferences
   - Adjust monitoring sensitivity
   - View privacy policy and terms & conditions

4. **Notifications**
   - Enable notifications to receive alerts about potential anxiety episodes
   - Customize notification sensitivity in settings

## Privacy and Data Usage

Horizon takes your privacy seriously. The application collects and processes physiological data from your Fitbit device solely for providing anxiety monitoring services. All data acquisition occurs exclusively through Fitbit's authorized OAuth 2.0 authentication framework and only after obtaining your explicit consent as required under GDPR.

For more details, please review our Privacy Policy and Terms & Conditions in the app settings.

## Development

### Prerequisites

- Flutter SDK (version 3.4.3 or higher)
- Dart SDK (version 3.4.3 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase account for backend services

### Setup

1. Clone the repository:

   ```
   git clone https://github.com/dylan-1006/horizon.git
   ```

2. Navigate to the project directory:

   ```
   cd horizon
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Create a .env file in the root directory with your Firebase and Fitbit API credentials

5. Run the app:
   ```
   flutter run
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please contact:

- Email: [horizon.horos@gmail.com](mailto:horizon.horos@gmail.com)

---

Built with ❤️ using Flutter and Firebase
