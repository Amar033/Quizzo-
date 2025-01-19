# Math Quiz App

A modern Flutter quiz application that helps users test and improve their knowledge on Genetics and Evolution  through an interactive interface.

## 📱 Features

- Clean, modern UI design
- Real-time question fetching from API
- Progress tracking
- Detailed explanations for answers
- Score tracking and results summary
- Responsive design for different screen sizes

## 🛠️ Prerequisites

Before running this project, make sure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (2.0.0 or higher)
- [Dart](https://dart.dev/get-dart) (2.12.0 or higher)
- A suitable IDE (VS Code, Android Studio, or IntelliJ)
- Git for version control

## 📥 Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/Quizzo-.git
```

2. Navigate to the project directory
```bash
cd quiz-app
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## ⚙️ Configuration

To configure the app to use your own API:
1. Open `lib/services/quiz_service.dart`
2. Update the `apiUrl` variable with your endpoint
```dart
final String apiUrl = 'your-api-endpoint';
```

## 📚 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── question.dart
│   └── option.dart
├── screens/
│   ├── start_screen.dart
│   ├── quiz_screen.dart
│   └── result_screen.dart
├── services/
│   └── quiz_service.dart
└── utils/
    └── app_colors.dart
```

## 🎨 Customization

### Colors
You can customize the app's color scheme by modifying the `AppColors` class:
```dart
class AppColors {
  static const Color primary = Color(0xFF2A9D8F);
  static const Color secondary = Color(0xFFE76F51);
  // ...
}
```

## 📱 Screenshots

![ui1](https://github.com/Amar033/Quizzo-/blob/main/ui%20output/1.jpeg)
![ui2](https://github.com/Amar033/Quizzo-/blob/main/ui%20output/2.jpeg)
![ui3](https://github.com/Amar033/Quizzo-/blob/main/ui%20output/3.jpeg)
![ui4](https://github.com/Amar033/Quizzo-/blob/main/ui%20output/4.jpeg)


## 👥 Authors

- Amardeep - [GitHub Profile](https://github.com/Amar033)

## 🙏 Acknowledgments

- The UI of the application was deeply inspired by the work I am citing below.
-[ref](https://in.pinterest.com/pin/425168021077168379/)
- I have used claude.ai to optimize my handwritten code and improve the ui elements


## Thank You 
```Thank you
Thank you for taking your time to read throught my work
```
