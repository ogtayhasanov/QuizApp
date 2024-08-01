import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Question> _questions = [
    Question('What is the capital of France?', 'Paris',
        ['Paris', 'London', 'Rome', 'Berlin']),
    Question('What is 2 + 2?', '4', ['3', '4', '5', '6']),
    Question('What is the largest planet in our solar system?', 'Jupiter',
        ['Mars', 'Earth', 'Jupiter', 'Saturn']),
  ];

  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  String _feedback = '';

  void _submitAnswer() {
    if (_selectedAnswer == _questions[_currentQuestionIndex].correctAnswer) {
      setState(() {
        _feedback = 'Correct!';
      });
    } else {
      setState(() {
        _feedback =
            'Incorrect. The correct answer is ${_questions[_currentQuestionIndex].correctAnswer}.';
      });
    }

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _feedback = '';
        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
          _selectedAnswer = null;
        } else {
          _showCompletionDialog();
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('You have completed the quiz!'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _selectedAnswer = null;
                _feedback = '';
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.text,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ...question.options.map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswer = value;
                    });
                  },
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer == null ? null : _submitAnswer,
              child: Text('Submit Answer'),
            ),
            SizedBox(height: 20),
            Text(
              _feedback,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String text;
  final String correctAnswer;
  final List<String> options;

  Question(this.text, this.correctAnswer, this.options);
}
