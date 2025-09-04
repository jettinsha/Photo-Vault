# Secure Photo Gallery

A beautiful and secure Flutter photo gallery app that preserves your photos locally using Hive database, ensuring your memories are always accessible even if they're deleted from your device's gallery.

## 🌟 Features

- **Secure Local Storage**: Photos are stored locally using Hive database, independent of system gallery
- **Multi-Photo Selection**: Select multiple photos at once from your gallery
- **Beautiful Grid Layout**: Masonry grid layout with smooth animations
- **Full-Screen Viewer**: Immersive photo viewing experience with zoom and swipe navigation
- **Dark/Light Theme Support**: Automatic theme switching based on system preferences
- **Offline Access**: All photos are available offline
- **Privacy Focused**: Photos remain private within the app
- **Hardware Back Button**: Configured to close app directly without data loss

## 📱 Screenshots

*Add your app screenshots here*

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd secure_photo_gallery
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Hive adapters)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34
- Permissions are automatically handled

#### iOS
- Minimum iOS version: 11.0
- Photo library permissions configured in Info.plist
- Camera permissions included

## 📂 Project Structure

```
lib/
├── models/
│   ├── photo_model.dart          # Photo data model with Hive annotations
│   └── photo_model.g.dart        # Generated Hive adapter
├── screens/
│   ├── home_screen.dart          # Main screen with photo grid
│   ├── add_photo_screen.dart     # Photo selection screen
│   └── full_screen_photo.dart    # Full-size photo viewer with zoom
├── services/
│   ├── hive_service.dart         # Hive database operations
│   └── image_service.dart        # Image picking and processing
├── widgets/
│   └── photo_grid_item.dart      # Individual grid item widget
└── main.dart                     # App initialization and theming
```

## 🛠️ Dependencies

### Core Dependencies
- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Hive Flutter integration
- `path_provider: ^2.1.1` - File system paths
- `image_picker: ^1.0.4` - Image selection from gallery
- `photo_view: ^0.14.0` - Photo zoom and pan functionality
- `flutter_staggered_grid_view: ^0.7.0` - Masonry grid layout

### Dev Dependencies
- `hive_generator: ^2.0.1` - Code generation for Hive
- `build_runner: ^2.4.7` - Build system

## 🎨 UI/UX Features

### Design Principles
- **Material Design 3**: Modern, clean interface
- **Smooth Animations**: Fade, slide, and scale animations
- **Responsive Layout**: Adapts to different screen sizes
- **Intuitive Navigation**: Easy-to-use gesture controls
- **Visual Feedback**: Haptic feedback and loading states

### Theme Support
- **Light Theme**: Clean, bright interface
- **Dark Theme**: Eye-friendly dark interface with OLED-friendly blacks
- **System Theme**: Automatically switches based on device settings

### Animations
- **Page Transitions**: Smooth slide and fade transitions
- **Grid Item Animations**: Scale and opacity effects on interaction
- **Loading States**: Skeleton loading and progress indicators
- **Gesture Feedback**: Visual and haptic feedback

## 🔧 Configuration

### Build Configuration

1. **Generate Hive Adapters** (Required after model changes):
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Build for Release**:
   ```bash
   # Android
   flutter build apk --release
   flutter build appbundle --release
   
   # iOS
   flutter build ios --release
   ```

### Customization

#### Changing Theme Colors
Edit the theme configuration in `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.yourColor, // Change this
  brightness: Brightness.light,
),
```

#### Grid Layout Configuration
Modify the grid settings in `lib/screens/home_screen.dart`:
```dart
MasonryGridView.count(
  crossAxisCount: 2, // Change column count
  mainAxisSpacing: 8, // Vertical spacing
  crossAxisSpacing: 8, // Horizontal spacing
  // ...
)
```

## 📊 Storage Information

The app provides storage information including:
- Total number of photos
- Storage space used
- Individual photo details (size, date added)

## 🔒 Privacy & Security

- **Local Storage Only**: Photos never leave your device
- **No Internet Required**: Completely offline functionality
- **No Analytics**: No user data collection
- **Secure File Handling**: Photos stored in app's private directory

## 🐛 Troubleshooting

### Common Issues

1. **Build Runner Issues**:
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Permission Issues**:
   - Ensure permissions are properly configured in `AndroidManifest.xml` and `Info.plist`
   - Check device settings for app permissions

3. **Photo Loading Issues**:
   - Verify file paths are correct
   - Check storage permissions
   - Clear app cache if needed

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive team for the efficient local database
- Contributors to all the open-source packages used

## 📞 Support

If you encounter any issues or have questions:
1. Check the [Issues](../../issues) section
2. Create a new issue with detailed information
3. Contact the development team

---

**Made with ❤️ using Flutter**