import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Question {
  final int id;
  final String description;
  final String topic;
  final String detailedSolution;
  final List<Option> options;
  final bool isPublished;

  Question({
    required this.id,
    required this.description,
    required this.topic,
    required this.detailedSolution,
    required this.options,
    required this.isPublished,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      description: json['description'],
      topic: json['topic'] ?? '',
      detailedSolution: json['detailed_solution'] ?? '',
      isPublished: json['is_published'] ?? false,
      options: (json['options'] as List)
          .map((option) => Option.fromJson(option))
          .toList(),
    );
  }
}

class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      description: json['description'],
      isCorrect: json['is_correct'],
    );
  }
}

// Custom Colors
class AppColors {
  static const Color primary = Color(0xFF2A9D8F);
  static const Color secondary = Color(0xFFE76F51);
  static const Color background = Color(0xFFFFF8F4);
  static const Color cardBackground = Colors.white;
  static const Color optionBackground = Color(0xFFE9967A);
}

// Quiz Service
class QuizService {
  final String apiUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> questionsJson = data['questions'];
        return questionsJson.map((json) => Question.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

// Start Screen
class StartQuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Quizzo!!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Test your Knowledge!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.help_outline, 'Total Questions', '10'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.timer_outlined, 'Time Limit', '15 mins'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.star_outline, 'Points per Question', '10'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Quiz Screen
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  List<Question> _questions = [];
  bool _isLoading = true;
  String? _error;
  Map<int, int> _selectedAnswers = {};
  int _currentQuestionIndex = 0;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _quizService.fetchQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading questions',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadQuestions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

Question currentQuestion = _questions[_currentQuestionIndex];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200],
                    ),
                    child: FractionallySizedBox(
                      widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: Text(
                      '${_currentQuestionIndex + 1}/${_questions.length}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),)
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentQuestion.description,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ...currentQuestion.options.map((option) =>
                          _buildAnswerOption(option, currentQuestion)),
                      if (_showExplanation) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Explanation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentQuestion.detailedSolution,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            // Navigation buttons in a fixed position
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentQuestionIndex--;
                          _showExplanation = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _selectedAnswers.containsKey(currentQuestion.id)
                        ? () {
                            if (_currentQuestionIndex < _questions.length - 1) {
                              setState(() {
                                _currentQuestionIndex++;
                                _showExplanation = false;
                              });
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    questions: _questions,
                                    answers: _selectedAnswers,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? 'Finish'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAnswerOption(Option option, Question question) {
    bool isSelected = _selectedAnswers[question.id] == option.id;
    bool showCorrect = _showExplanation && option.isCorrect;
    
    return GestureDetector(
      onTap: () {
        if (!_showExplanation) {
          setState(() {
            _selectedAnswers[question.id] = option.id;
            _showExplanation = true;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: showCorrect
              ? AppColors.primary
              : (isSelected ? AppColors.optionBackground : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: showCorrect
                ? AppColors.primary
                : (isSelected ? AppColors.optionBackground : Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.description,
                style: TextStyle(
                  color: isSelected || showCorrect ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showCorrect)
              const Icon(Icons.check_circle, color: Colors.white),
            if (isSelected && !option.isCorrect)
              const Icon(Icons.close, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Result Screen
class ResultScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int> answers;

  const ResultScreen({
    Key? key,
    required this.questions,
    required this.answers,
  }) : super(key: key);

  int calculateScore() {
    int score = 0;
    answers.forEach((questionId, selectedOptionId) {
      final question = questions.firstWhere((q) => q.id == questionId);
      final selectedOption = question.options.firstWhere((o) => o.id == selectedOptionId);
      if (selectedOption.isCorrect) score++;
    });
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final score = calculateScore();
    final percentage = (score / questions.length) * 100;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey[200],
                            color: AppColors.primary,
                            strokeWidth: 12,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${percentage.toInt()}%',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '$score/${questions.length}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _getResultMessage(percentage),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartQuizScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartQuizScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 90) {
      return 'Excellent! You\'re a master!';
    } else if (percentage >= 70) {
      return 'Great job! Keep it up!';
    } else if (percentage >= 50) {
      return 'Good effort! Room for improvement.';
    } else {
      return 'Keep practicing! You\'ll get better.';
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: StartQuizScreen(),
    );
  }
}


//Hand written code:
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// // Models
// class Question {
//   final int id;
//   final String description;
//   final String topic;
//   final String detailedSolution;
//   final List<Option> options;
//   final bool isPublished;

//   Question({
//     required this.id,
//     required this.description,
//     required this.topic,
//     required this.detailedSolution,
//     required this.options,
//     required this.isPublished,
//   });

//   factory Question.fromJson(Map<String, dynamic> json) {
//     return Question(
//       id: json['id'],
//       description: json['description'],
//       topic: json['topic'] ?? '',
//       detailedSolution: json['detailed_solution'] ?? '',
//       isPublished: json['is_published'] ?? false,
//       options: (json['options'] as List)
//           .map((option) => Option.fromJson(option))
//           .toList(),
//     );
//   }
// }

// class Option {
//   final int id;
//   final String description;
//   final bool isCorrect;

//   Option({
//     required this.id,
//     required this.description,
//     required this.isCorrect,
//   });

//   factory Option.fromJson(Map<String, dynamic> json) {
//     return Option(
//       id: json['id'],
//       description: json['description'],
//       isCorrect: json['is_correct'],
//     );
//   }
// }

// // Service
// class QuizService {
//   final String apiUrl = 'https://api.jsonserve.com/Uw5CrX';

// Future<List<Question>> fetchQuestions() async {
//   try {
//     print('Fetching questions from: $apiUrl');
//     final response = await http.get(Uri.parse(apiUrl));
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
    
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       final List<dynamic> questionsJson = data['questions'];
//       return questionsJson.map((json) => Question.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   } catch (e) {
//     print('Error fetching questions: $e');
//     throw Exception('Error: $e');
//   }
// }
// }

// // Quiz Screen
// class QuizScreen extends StatefulWidget {
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   final QuizService _quizService = QuizService();
//   List<Question> _questions = [];
//   bool _isLoading = true;
//   String? _error;
//   Map<int, int> _selectedAnswers = {};
//   int _currentQuestionIndex = 0;
//   bool _showResults = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadQuestions();
//   }

//   Future<void> _loadQuestions() async {
//     try {
//       final questions = await _quizService.fetchQuestions();
//       setState(() {
//         _questions = questions;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   void _nextQuestion() {
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//       });
//     } else {
//       setState(() {
//         _showResults = true;
//       });
//     }
//   }

//   void _previousQuestion() {
//     if (_currentQuestionIndex > 0) {
//       setState(() {
//         _currentQuestionIndex--;
//       });
//     }
//   }

//   int _calculateScore() {
//     int score = 0;
//     _selectedAnswers.forEach((questionId, selectedOptionId) {
//       final question = _questions.firstWhere((q) => q.id == questionId);
//       final selectedOption = question.options.firstWhere((o) => o.id == selectedOptionId);
//       if (selectedOption.isCorrect) {
//         score++;
//       }
//     });
//     return score;
//   }

//   Widget _buildQuestionCard(Question question) {
//     return Card(
//       margin: const EdgeInsets.all(16.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Question ${_currentQuestionIndex + 1} of ${_questions.length}:',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               question.description,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 16.0),
//             ...question.options.map((option) {
//               return RadioListTile<int>(
//                 title: Text(option.description),
//                 value: option.id,
//                 groupValue: _selectedAnswers[question.id],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedAnswers[question.id] = value!;
//                   });
//                 },
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResults() {
//     final score = _calculateScore();
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Quiz Complete!',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: 16.0),
//           Text(
//             'Your Score: $score/${_questions.length}',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(height: 24.0),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _showResults = false;
//                 _currentQuestionIndex = 0;
//                 _selectedAnswers.clear();
//               });
//             },
//             child: const Text('Restart Quiz'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_error != null) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Error: $_error'),
//               ElevatedButton(
//                 onPressed: _loadQuestions,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quiz'),
//       ),
//       body: _showResults
//           ? _buildResults()
//           : Column(
//               children: [
//                 Expanded(
//                   child: _buildQuestionCard(_questions[_currentQuestionIndex]),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       if (_currentQuestionIndex > 0)
//                         ElevatedButton(
//                           onPressed: _previousQuestion,
//                           child: const Text('Previous'),
//                         ),
//                       ElevatedButton(
//                         onPressed: _selectedAnswers
//                                 .containsKey(_questions[_currentQuestionIndex].id)
//                             ? _nextQuestion
//                             : null,
//                         child: Text(_currentQuestionIndex == _questions.length - 1
//                             ? 'Finish'
//                             : 'Next'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
// class StartScreen extends StatefulWidget {
//   const StartScreen({super.key});

//   @override
//   State<StartScreen> createState() => _StartScreenState();
// }

// class _StartScreenState extends State<StartScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(padding:EdgeInsets.all(8.0),child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Quizzo'),
//           ElevatedButton(onPressed: (){
//             Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) =>  QuizScreen()),
//   );
//           }, child: Text('Start Quiz'))
//         ],
//       ),) 
      
//     );
//   }
// }

// // Main App
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: StartScreen() //QuizScreen(),
//     );
//   }
// }
