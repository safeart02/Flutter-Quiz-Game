import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      home: SplashScreen(),
    );
  }
}

class QuizProvider with ChangeNotifier {
  String _name = '';
  Map<String, int> _scores = {};

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String get name => _name;

  void setScore(String category, int score) {
    _scores[category] = score;
    notifyListeners();
  }

  Map<String, int> get allScores => _scores;
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'LOGO HERE',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _controller.text;
                Provider.of<QuizProvider>(context, listen: false).setName(name);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu()),
                );
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<QuizProvider>(context).name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => MenuSheet(),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Mabuhay, $name!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WikaKulturaScreen()));
              },
              child: Text('Wika at Kultura'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LarawanLahiScreen()));
              },
              child: Text('Larawan ng Lahi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaderboardsScreen()));
              },
              child: Text('Leaderboards'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: Text('Leaderboards'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign out'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class WikaKulturaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wika at Kultura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KasaysayanScreen()));
              },
              child: Text('Kasaysayan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TalasalitaanScreen()));
              },
              child: Text('Talasalitaan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GramatikaScreen()));
              },
              child: Text('Gramatika'),
            ),
          ],
        ),
      ),
    );
  }
}

class KasaysayanScreen extends StatefulWidget {
  @override
  _KasaysayanScreenState createState() => _KasaysayanScreenState();
}

class _KasaysayanScreenState extends State<KasaysayanScreen> {
  int _currentQuestionIndex = 0;
  List<Question> _questions = [
    Question('Question 1', ['A', 'B', 'C', 'D'], 'A'),
    Question('Question 2', ['A', 'B', 'C', 'D'], 'B'),
  ];
  String? _selectedAnswer;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kasaysayan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.question, style: TextStyle(fontSize: 24)),
            ...question.options.map((option) => ElevatedButton(
              onPressed: _selectedAnswer == null ? () {
                setState(() {
                  _selectedAnswer = option;
                  _isCorrect = option == question.correctAnswer;
                });
              } : null,
              child: Text(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAnswer == option
                    ? (_isCorrect == true ? Colors.green : Colors.red)
                    : null,
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? () {
                if (_isCorrect == true) {
                  Provider.of<QuizProvider>(context, listen: false).setScore('Kasaysayan', _currentQuestionIndex + 1);
                }
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedAnswer = null;
                    _isCorrect = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              } : null,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class TalasalitaanScreen extends StatefulWidget {
  @override
  _TalasalitaanScreenState createState() => _TalasalitaanScreenState();
}

class _TalasalitaanScreenState extends State<TalasalitaanScreen> {
  int _currentQuestionIndex = 0;
  List<Question> _questions = [
    Question('Question 1', ['A', 'B', 'C', 'D'], 'A'),
    Question('Question 2', ['A', 'B', 'C', 'D'], 'B'),
  ];
  String? _selectedAnswer;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Talasalitaan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.question, style: TextStyle(fontSize: 24)),
            ...question.options.map((option) => ElevatedButton(
              onPressed: _selectedAnswer == null ? () {
                setState(() {
                  _selectedAnswer = option;
                  _isCorrect = option == question.correctAnswer;
                });
              } : null,
              child: Text(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAnswer == option
                    ? (_isCorrect == true ? Colors.green : Colors.red)
                    : null,
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? () {
                if (_isCorrect == true) {
                  Provider.of<QuizProvider>(context, listen: false).setScore('Talasalitaan', _currentQuestionIndex + 1);
                }
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedAnswer = null;
                    _isCorrect = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              } : null,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class GramatikaScreen extends StatefulWidget {
  @override
  _GramatikaScreenState createState() => _GramatikaScreenState();
}

class _GramatikaScreenState extends State<GramatikaScreen> {
  int _currentQuestionIndex = 0;
  List<Question> _questions = [
    Question('Question 1', ['A', 'B', 'C', 'D'], 'A'),
    Question('Question 2', ['A', 'B', 'C', 'D'], 'B'),
  ];
  String? _selectedAnswer;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Gramatika'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.question, style: TextStyle(fontSize: 24)),
            ...question.options.map((option) => ElevatedButton(
              onPressed: _selectedAnswer == null ? () {
                setState(() {
                  _selectedAnswer = option;
                  _isCorrect = option == question.correctAnswer;
                });
              } : null,
              child: Text(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAnswer == option
                    ? (_isCorrect == true ? Colors.green : Colors.red)
                    : null,
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? () {
                if (_isCorrect == true) {
                  Provider.of<QuizProvider>(context, listen: false).setScore('Gramatika', _currentQuestionIndex + 1);
                }
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedAnswer = null;
                    _isCorrect = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              } : null,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class LarawanLahiScreen extends StatefulWidget {
  @override
  _LarawanLahiScreenState createState() => _LarawanLahiScreenState();
}

class _LarawanLahiScreenState extends State<LarawanLahiScreen> {
  int _currentRoundIndex = 0;

  List<List<String>> _imageSets = [
    ['assets/images/image1.png', 'assets/images/image2.png', 'assets/images/image3.png'],
    ['assets/images/image4.png', 'assets/images/image5.png', 'assets/images/image6.png'],
    ['assets/images/image7.png', 'assets/images/image8.png', 'assets/images/image9.png'],
  ];

  List<List<String>> _correctAnswers = [
    ['Word1', 'Word2', 'Word3'],
    ['Word4', 'Word5', 'Word6'],
    ['Word7', 'Word8', 'Word9'],
  ];

  String? _draggedWord;
  String? _correctImage;
  bool? _isCorrect;

  @override
  Widget build(BuildContext context) {
    List<String> currentImages = _imageSets[_currentRoundIndex];
    List<String> correctAnswers = _correctAnswers[_currentRoundIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Larawan ng Lahi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: currentImages.map((image) {
                return DragTarget<String>(
                  onAccept: (data) {
                    setState(() {
                      _correctImage = correctAnswers.contains(data) ? image : null;
                      _isCorrect = correctAnswers.contains(data);
                    });
                    if (_isCorrect == true) {
                      Provider.of<QuizProvider>(context, listen: false).setScore('Larawan ng Lahi', 1);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: 100,
                      width: 100,
                      color: (_isCorrect == true && _correctImage == image)
                          ? Colors.green
                          : (_isCorrect == false && _correctImage == image)
                              ? Colors.red
                              : Colors.transparent,
                      child: Image.asset(image, fit: BoxFit.cover),
                    );
                  },
                );
              }).toList(),
            ),
            Draggable<String>(
              data: correctAnswers.first,
              child: Chip(label: Text(correctAnswers.first)),
              feedback: Chip(label: Text(correctAnswers.first), backgroundColor: Colors.blue),
              childWhenDragging: Chip(label: Text(correctAnswers.first), backgroundColor: Colors.grey),
            ),
            ElevatedButton(
              onPressed: _isCorrect != null ? () {
                if (_currentRoundIndex < _imageSets.length - 1) {
                  setState(() {
                    _currentRoundIndex++;
                    _correctImage = null;
                    _isCorrect = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              } : null,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scores = Provider.of<QuizProvider>(context).allScores;
    final name = Provider.of<QuizProvider>(context).name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboards'),
      ),
      body: ListView(
        children: scores.entries.map((entry) {
          return ListTile(
            title: Text('Category: ${entry.key}'),
            subtitle: Text('Score: ${entry.value}'),
            trailing: Text(name),
          );
        }).toList(),
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question(this.question, this.options, this.correctAnswer);
}
