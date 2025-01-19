# Math Quiz App

A modern Flutter quiz application that helps users test and improve their mathematical skills through an interactive interface.

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
git clone https://github.com/yourusername/quiz-app.git
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

## 📊 API Response Format

The API should return data in the following format:
```json
{
  "questions": [
    {
      "id": 1,
      "description": "Question text",
      "topic": "Math",
      "detailed_solution": "Explanation text",
      "options": [
        {
          "id": 1,
          "description": "Option text",
          "is_correct": true
        }
      ],
      "is_published": true
    }
  ]
}
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

### Styling
The app uses Material Design and can be customized through the `ThemeData` in `main.dart`.

## 📱 Screenshots

![ui1](https://github.com/Amar033/Quizzo-/tree/main/ui%20output/1.jpeg?raw=true)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## 👥 Authors

- Your Name - [GitHub Profile](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- [List any other resources or inspirations]
