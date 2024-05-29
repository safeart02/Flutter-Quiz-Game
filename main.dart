import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
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
                  MaterialPageRoute(builder: (context) => MainPage(name: name)),
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

class MainPage extends StatelessWidget {
  final String name;

  MainPage({required this.name});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {},
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
              onPressed: () {
                setState(() {
                  _selectedAnswer = option;
                });
              },
              child: Text(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAnswer == option ? Colors.blue : null,
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedAnswer = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
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
            // Replace this with an Image widget for the actual image
            Placeholder(fallbackHeight: 200),
            Text(question.question, style: TextStyle(fontSize: 24)),
            ...question.options.map((option) => ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedAnswer = option;
                });
              },
              child: Text(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAnswer == option ? Colors.blue : null,
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedAnswer = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class GramatikaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gramatika'),
      ),
      body: Center(
        child: Text('Gramatika Screen'),
      ),
    );
  }
}

class LarawanLahiScreen extends StatefulWidget {
  @override
  _LarawanLahiScreenState createState() => _LarawanLahiScreenState();
}

class _LarawanLahiScreenState extends State<LarawanLahiScreen> {
  List<String> words = ['Bahay', 'Lupa', 'Puno'];
  List<String> images = [
    'assets/images/bahay.jpg',
    'assets/images/lupa.jpg',
    'assets/images/puno.jpg'
  ];
  int currentIndex = 0;
  bool isCorrect = false;

  void _nextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % words.length;
      isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Larawan ng Lahi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: images.map((image) {
              return DragTarget<String>(
                onAccept: (receivedItem) {
                  setState(() {
                    isCorrect = (receivedItem == words[images.indexOf(image)]);
                    if (isCorrect) _nextQuestion();
                  });
                },
                builder: (context, acceptedItems, rejectedItems) {
                  return Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(image),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isCorrect && words[images.indexOf(image)] == words[currentIndex]
                            ? Colors.green
                            : Colors.black,
                        width: 2,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Draggable<String>(
            data: words[currentIndex],
            feedback: Material(
              child: Text(words[currentIndex],
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            childWhenDragging: Container(),
            child: Text(words[currentIndex],
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _nextQuestion,
            child: Text('Next'),
          ),
        ],
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

class QuizProvider with ChangeNotifier {
  String _name = '';

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String get name => _name;
}
