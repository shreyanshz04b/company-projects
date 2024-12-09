import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InterviewPreparationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Preparation'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two cards per row
          childAspectRatio: 1.5, // Adjust the aspect ratio to your liking
          children: [
            _buildCard(context, 'Technical Questions', Icons.code, Colors.blue, ),
            _buildCard(context, 'Coding Questions', Icons.computer, Colors.green),
            _buildCard(context, 'Aptitude Questions', Icons.calculate, Colors.orange, AptitudeQuestionsScreen()),
            _buildCard(context, 'Verbal Questions', Icons.language, Colors.red),
            _buildCard(context, 'HR Interview Questions', Icons.person, Colors.purple, HRInterviewQuestionsScreen()),
            _buildCard(context, 'Group Discussion Topics', Icons.group, Colors.teal, GroupDiscussionScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color, [Widget? screen]) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          _showDetails(context, title);
        }
      },
      child: Card(
        elevation: 4,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Here are some resources for $title.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class GroupDiscussionScreen extends StatefulWidget {
  @override
  _GroupDiscussionScreenState createState() => _GroupDiscussionScreenState();
}

class _GroupDiscussionScreenState extends State<GroupDiscussionScreen> {
  List<String> topics = [];
  bool isLoading = true;
  String errorMessage = ''; // Error handling message

  @override
  void initState() {
    super.initState();
    _loadTopicsFromGoogleDoc();
  }

  Future<void> _loadTopicsFromGoogleDoc() async {
    const String documentId = '11T9s_FsEiVVysuF-kyIOnNOu6jK5kXf60ofVw_MQn3o';
    const String url = 'https://docs.google.com/document/d/$documentId/export?format=txt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          topics = response.body.split('\n').map((topic) => topic.trim()).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load topics, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch topics. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Discussion Topics'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTopicsFromGoogleDoc, // Refresh topics
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage)) // Display error message
            : topics.isEmpty
            ? Center(child: Text('No topics loaded.'))
            : ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return _buildTopicCard(topics[index]);
          },
        ),
      ),
    );
  }

  Widget _buildTopicCard(String topic) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(Icons.topic, color: Colors.blue),
        title: Text(
          topic,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Click for details',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          _showTopicDetails(topic);
        },
      ),
    );
  }

  void _showTopicDetails(String topic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(topic),
          content: Text('Details about the topic: $topic'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class HRInterviewQuestionsScreen extends StatefulWidget {
  @override
  _HRInterviewQuestionsScreenState createState() => _HRInterviewQuestionsScreenState();
}

class _HRInterviewQuestionsScreenState extends State<HRInterviewQuestionsScreen> {
  List<String> questions = [];
  List<String> answers = [];
  bool isLoading = true;
  String errorMessage = ''; // Error handling message

  @override
  void initState() {
    super.initState();
    _loadQuestionsFromGoogleDoc();
  }

  Future<void> _loadQuestionsFromGoogleDoc() async {
    const String documentId = '1muaQDQ5lqQvD9tHXFugF3wcNlxThx5u4M6LQHUgvlXI'; // Replace with your Google Doc ID
    const String url = 'https://docs.google.com/document/d/$documentId/export?format=txt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<String> lines = response.body.split('\n').map((line) => line.trim()).toList();
        for (var i = 0; i < lines.length; i += 2) {
          if (i + 1 < lines.length) {
            questions.add(lines[i]); // Add the question
            answers.add(lines[i + 1]); // Add the corresponding answer
          }
        }
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load questions, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch questions. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Interview Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadQuestionsFromGoogleDoc, // Refresh questions
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage)) // Display error message
            : questions.isEmpty
            ? Center(child: Text('No questions loaded.'))
            : ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return _buildQuestionCard(index);
          },
        ),
      ),
    );
  }
v
  Widget _buildQuestionCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(Icons.question_answer, color: Colors.blue),
        title: Text(
          questions[index],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Tap for answer',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          _showAnswerDialog(index);
        },
      ),
    );
  }

  void _showAnswerDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Answer'),
          content: Text(answers[index]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class AptitudeQuestionsScreen extends StatefulWidget {
  @override
  _AptitudeQuestionsScreenState createState() => _AptitudeQuestionsScreenState();
}

class _AptitudeQuestionsScreenState extends State<AptitudeQuestionsScreen> {
  List<String> questions = [];
  List<String> answers = [];
  bool isLoading = true;
  String errorMessage = ''; // Error handling message

  @override
  void initState() {
    super.initState();
    _loadQuestionsFromGoogleDoc();
  }

  Future<void> _loadQuestionsFromGoogleDoc() async {
    const String documentId = '1WzGiz5bzIMmbtUOoElDGGoetgB7AdbfRye1bwagKKHA'; // Replace with your Google Doc ID
    const String url = 'https://docs.google.com/document/d/$documentId/export?format=txt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<String> lines = response.body.split('\n').map((line) => line.trim()).toList();
        for (var i = 0; i < lines.length; i += 2) {
          if (i + 1 < lines.length) {
            questions.add(lines[i]); // Add the question
            answers.add(lines[i + 1]); // Add the corresponding answer
          }
        }
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load questions, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch questions. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aptitude Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadQuestionsFromGoogleDoc, // Refresh questions
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage)) // Display error message
            : questions.isEmpty
            ? Center(child: Text('No questions loaded.'))
            : ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return _buildQuestionCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(Icons.question_answer, color: Colors.blue),
        title: Text(
          questions[index],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Tap for answer',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          _showAnswerDialog(index);
        },
      ),
    );
  }

  void _showAnswerDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Answer'),
          content: Text(answers[index]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InterviewPreparationScreen(),
  ));
}
