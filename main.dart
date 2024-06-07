import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizProvider()..loadFromPreferences(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HideNotificationBar(
      child: MaterialApp(
        title: 'Quiz App',
        home: SplashScreen(),
      ),
    );
  }
}

class HideNotificationBar extends StatelessWidget {
  final Widget child;

  HideNotificationBar({required this.child});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    return child;
  }
}

final player = AudioPlayer();

class QuizProvider with ChangeNotifier {
  String _name = '';
  Map<String, int> _scores = {};

  void setName(String name) {
    _name = name;
    notifyListeners();
    _saveToPreferences();
  }

  String get name => _name;

  void setScore(String category, int score) {
    _scores[category] = score;
    notifyListeners();
    _saveToPreferences();
  }

  Map<String, int> get allScores => _scores;

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _name);
    prefs.setString('scores', _scores.entries.map((e) => '${e.key}:${e.value}').join(','));
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _scores = Map.fromEntries(
      (prefs.getString('scores') ?? '')
          .split(',')
          .where((e) => e.contains(':'))
          .map((e) {
            final parts = e.split(':');
            return MapEntry(parts[0], int.parse(parts[1]));
          }),
    );
    notifyListeners();
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
        child: Image.asset(
          'assets/images/TuklasPilipinas_LOGO.png',
          fit: BoxFit.cover,
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
              onPressed: () async {
                await player.setSource(AssetSource('sounds/phantom.mp3'));
                await player.resume();
                
                String name = _controller.text;
                Provider.of<QuizProvider>(context, listen: false).setName(name);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
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

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<QuizProvider>(context).name;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background with red color
          Container(
            color: Colors.red,
          ),
          // Animated Background
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                spawnMaxRadius: 50,
                spawnMinSpeed: 10.00,
                particleCount: 30,
                spawnMaxSpeed: 50,
                minOpacity: 0.2,
                spawnOpacity: 0.8,
                image: Image.asset('assets/bg/star.png'),
              ),
            ),
            vsync: this,
            child: Container(), // Required child parameter, we can use an empty container
          ),
          // Foreground with buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mabuhay, $name!',
                  style: TextStyle(
                    fontFamily: 'custom_font2',
                    fontSize: 60,
                    color: Colors.white, // Set text color to contrast with background
                  ),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/start_icon.png',
                    width: 800, // Set the width as needed
                    height: 100, // Set the height as needed
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu()),
                    );
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/aboutus_icon.png',
                    width: 800, // Set the width as needed
                    height: 80, // Set the height as needed
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu()),
                    );
                  },
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/exit_icon.png',
                    width: 800, // Set the width as needed
                    height: 80, // Set the height as needed
                  ),
                  onPressed: () {
                    exit(0);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}
class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<QuizProvider>(context).name;

    return Scaffold(
      appBar: AppBar(
        title: Text('TUKLAS PILIPINAS'),
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
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 50,
            spawnMinSpeed: 10.00,
            particleCount: 30,
            spawnMaxSpeed: 50,
            minOpacity: 0.3,
            spawnOpacity: 0.4,
            baseColor: Colors.blue,
          )
        ),
        vsync: this,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PUMILI NG KATEGORYA:', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await player.setReleaseMode(ReleaseMode.release);
                await player.play(AssetSource('sounds/start_screen.mp3'));
                await player.resume();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WikaKulturaScreen()));
              },
              child: Text('Wika at Kultura'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await player.setReleaseMode(ReleaseMode.release);
                await player.play(AssetSource('sounds/quiz_start.mp3'));
                await player.resume();
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
        )
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
              onPressed: () async {
                await player.play(AssetSource('sounds/quiz_start.mp3'));
                await player.resume();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KasaysayanScreen()));
              },
              child: Text('Kasaysayan'),
            ),
            ElevatedButton(
              onPressed: () async {
                await player.play(AssetSource('sounds/quiz_start.mp3'));
                await player.resume();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TalasalitaanScreen()));
              },
              child: Text('Talasalitaan'),
            ),
            ElevatedButton(
              onPressed: () async {
                await player.play(AssetSource('sounds/quiz_start.mp3'));
                await player.resume();
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

class KasaysayanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuizScreen(
      title: 'Kasaysayan',
      questions: [
        Question('Anong taon dumating ang grupo ng mag Portuguese explorer na si Ferdinand Magellan sa Pilipinas at ang unang pakikipag-ugnayan ng mag Kastila sa mag Katutubong Pilipino.', ['A. Mayo 18, 1521', 'B. Marso 16, 1521', 'C. Mayo 16, 1622', 'D. Abril 17, 1656'], 'B. Marso 16, 1521',''),
        Question('Kailan naganap ang una misa sa Pilipinas noong araw ng Linggo ng Pagkabuhay?', ['A. Enero 4, 1521', 'B. Disyembre 25, 1521', 'C. Mayo 20, 1521', 'D. Marso 31, 1521'], 'D. Marso 31, 1521',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'A',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'A',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'A',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'A',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'A',''),
        Question('Kasaysayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),

      ],
      category: 'Kasaysayan',
    );
  }
}

class TalasalitaanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TalasalitaanQuizScreen(
        questions: [
          Question('Ano ang kahulugan ng "bahaghari"?', ['Rainbow', 'Mountain', 'River', 'Sky'], 'Rainbow', 'assets/images/talasalitaan1.png'),
          Question('Ano ang kahulugan ng "bituin"?', ['Star', 'Sun', 'Moon', 'Planet'], 'Star', 'assets/images/talasalitaan2.png'),
        ],
        category: 'Talasalitaan',
      ),
    );
  }
}

class GramatikaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuizScreen(
      title: 'Gramatika',
      questions: [
        Question('Karunungang Bayan Question 1', ['A', 'B', 'C', 'D'], 'A',''),
        Question('Karunungang Bayan Question 2', ['A', 'B', 'C', 'D'], 'B',''),
      ],
      category: 'Gramatika',
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String title;
  final List<Question> questions;
  final String category;

  QuizScreen({required this.title, required this.questions, required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  int _score = 0;

  void _showSnackbar(BuildContext context, bool isCorrect) {
    final snackBar = SnackBar(
      content: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.question, style: TextStyle(fontSize: 24)),
            ...question.options.map((option) => GestureDetector(
              onTap: _selectedAnswer == null ? () {
                setState(() {
                  _selectedAnswer = option;
                  _isCorrect = option == question.correctAnswer;
                });
                _showSnackbar(context, _isCorrect == true);
              } : null,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _selectedAnswer == option
                      ? (_isCorrect == true ? Colors.green : Colors.red)
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(option, style: TextStyle(color: Colors.white)),
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? () {
                if (_isCorrect == true) {
                  _score++;
                  Provider.of<QuizProvider>(context, listen: false).setScore(widget.category, _score);
                }
                if (_currentQuestionIndex < widget.questions.length - 1) {
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

class TalasalitaanQuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String category;

  TalasalitaanQuizScreen({required this.questions, required this.category});

  @override
  _TalasalitaanQuizScreenState createState() => _TalasalitaanQuizScreenState();
  
}

class _TalasalitaanQuizScreenState extends State<TalasalitaanQuizScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  int _score = 0;

  void _showSnackbar(BuildContext context, bool isCorrect) {
    final snackBar = SnackBar(
      content: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
void initState() {
  super.initState();
  // Shuffle the list of questions when the screen initializes
  List<Question> shuffledQuestions = List.from(widget.questions)..shuffle();
  // Select only the first 10 questions if there are more than 10
  if (shuffledQuestions.length > 10) {
    shuffledQuestions = shuffledQuestions.sublist(0, 10);
  }
  // Store the shuffled and trimmed questions in a local variable
  List<Question> trimmedQuestions = shuffledQuestions;
  // Now you can use trimmedQuestions in your widget for displaying questions.
}

  
  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Talasalitaan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(question.contextImage),
            Text(question.question, style: TextStyle(fontSize: 24)),
            ...question.options.map((option) => GestureDetector(
              onTap: _selectedAnswer == null ? () {
                setState(() {
                  _selectedAnswer = option;
                  _isCorrect = option == question.correctAnswer;
                });
                _showSnackbar(context, _isCorrect == true);
              } : null,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _selectedAnswer == option
                      ? (_isCorrect == true ? Colors.green : Colors.red)
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(option, style: TextStyle(color: Colors.white)),
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? () {
                if (_isCorrect == true) {
                  _score++;
                  Provider.of<QuizProvider>(context, listen: false).setScore(widget.category, _score);
                }
                if (_currentQuestionIndex < widget.questions.length - 1) {
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

class LarawanLahiScreen extends StatefulWidget {
  @override
  _LarawanLahiScreenState createState() => _LarawanLahiScreenState();
}

class _LarawanLahiScreenState extends State<LarawanLahiScreen> {
  int _currentRoundIndex = 0;
  int _score = 0;

  final List<List<String>> _imageSets = [
    ['assets/images/image1.png', 'assets/images/image2.png', 'assets/images/image3.png'],
    ['assets/images/image4.png', 'assets/images/image5.png', 'assets/images/image6.png'],
    ['assets/images/image7.png', 'assets/images/image8.png', 'assets/images/image9.png'],
  ];

  final List<String> _words = ['Word1', 'Word2', 'Word3'];
  final List<int> _correctImageIndices = [0, 1, 2];  // Define correct image index for each round

  String _currentWord = 'Word1';
  int _correctImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentWord = _words[_currentRoundIndex];
    _correctImageIndex = _correctImageIndices[_currentRoundIndex];
  }

  void _nextRound() {
    if (_currentRoundIndex < _imageSets.length - 1) {
      setState(() {
        _currentRoundIndex++;
        _currentWord = _words[_currentRoundIndex];
        _correctImageIndex = _correctImageIndices[_currentRoundIndex];
      });
    } else {
      _showGameOverDialog();
    }
  }

  void _showSnackbar(BuildContext context, bool isCorrect) {
    final snackBar = SnackBar(
      content: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showGameOverDialog() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.setScore('Larawan ng Lahi', _score);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score has been saved.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
          Text(
            'Round ${_currentRoundIndex + 1}: Drag the word to the correct image',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_imageSets[_currentRoundIndex].length, (index) {
              return DragTarget<String>(
                onAccept: (receivedWord) {
                  final isCorrect = receivedWord == _currentWord && index == _correctImageIndex;
                  _showSnackbar(context, isCorrect);
                  if (isCorrect) {
                    setState(() {
                      _score++;
                    });
                  }
                  _nextRound();
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: Image.asset(_imageSets[_currentRoundIndex][index]),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 40),
          Draggable<String>(
            data: _currentWord,
            child: Text(
              _currentWord,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            feedback: Material(
              color: Colors.transparent,
              child: Text(
                _currentWord,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            childWhenDragging: Container(),
            onDragCompleted: () {
              // You can add logic here if needed when the word is dragged
            },
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
  final String contextImage;

  Question(this.question, this.options, this.correctAnswer, this.contextImage);
}
