import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.yellowAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Welcome notification with emoji
          NotificationTile(
            title: 'Welcome to Hireflix! 🎉',
            message: 'We are excited to help you with your resume and interview prep!',
            onTap: () {
              // Action when tapped (could navigate to a welcome screen or show more details)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Welcome to Hireflix!')));
            },
          ),
          // Motivational quotes notification
          NotificationTile(
            title: 'Motivational Quote of the Day: 💪',
            message: '"Success is the sum of small efforts, repeated day in and day out." - Robert Collier',
            onTap: () {
              // Action when tapped (could show a detailed post or highlight this quote)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quote by Robert Collier')));
            },
          ),
          // Another motivational quote notification
          NotificationTile(
            title: 'Motivational Quote: 🌟',
            message: '"The harder you work for something, the greater you’ll feel when you achieve it." - Anonymous',
            onTap: () {
              // Action when tapped (could show a detailed post or highlight this quote)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quote by Anonymous')));
            },
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onTap;

  NotificationTile({
    required this.title,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> chatMessages = [];

  Map<String, List<String>> questionsAndAnswers = {
    'How can I improve my resume?': [
      'Great! Add skills that are relevant to the job you are applying for.',
      'Instead of listing responsibilities, focus on what you achieved in each role.',
      'Certifications and personal projects show your initiative and can help set you apart.',
      'Customize your resume to fit the job description, highlighting your most relevant experience.',
    ],
    'What are the best resume formats?': [
      'A chronological format is ideal if you have a strong and consistent work history.',
      'A functional format focuses on your skills and qualifications, useful for those changing careers.',
      'A combination format blends both chronological and functional formats, perfect for those with varied experiences.',
    ],
    'How can I make my resume stand out?': [
      'Use a clean, professional design.',
      'Highlight key accomplishments.',
      'Include metrics and results.',
    ],
  };

  @override
  void initState() {
    super.initState();
    chatMessages.add({'sender': 'Agent', 'message': 'Hey! How can I assist you today?'});
    Future.delayed(Duration(seconds: 1), _showQuestionsList);
  }

  // Show the list of predefined questions and their corresponding answers
  void _showQuestionsList() {
    setState(() {
      chatMessages.add({
        'sender': 'Agent',
        'message': 'Please select a question to learn more about resume improvement:',
      });
    });
  }

  // Handle option selection and provide answers
  void _handleOptionSelection(String question) {
    setState(() {
      chatMessages.add({'sender': 'You', 'message': question});
    });

    // Display the answers for the selected question
    List<String> answers = questionsAndAnswers[question] ?? [];
    for (var answer in answers) {
      setState(() {
        chatMessages.add({'sender': 'Agent', 'message': answer});
      });
    }

    // After showing the answers, ask for feedback
    Future.delayed(Duration(seconds: 2), _askForFeedback);
  }

  // Ask for feedback after providing answers
  void _askForFeedback() {
    setState(() {
      chatMessages.add({
        'sender': 'Agent',
        'message': 'Did this help you improve your resume? Please select an option below.',
      });
    });
  }

  // Show deeper answers or ask more questions if the user is satisfied
  void _askForMoreQuestions() {
    setState(() {
      chatMessages.add({
        'sender': 'Agent',
        'message': 'Would you like to explore more tips or ask additional questions?',
      });
    });
  }

  // If the user is not satisfied, show a message about the agent calling within 24 hours
  void _handleDissatisfaction() {
    setState(() {
      chatMessages.add({
        'sender': 'Agent',
        'message': 'We are sorry to hear that! Our agent will call you within 24 hours to assist you further.',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Agent'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${chatMessages[index]['sender']}: ${chatMessages[index]['message']}',
                      style: TextStyle(
                        fontWeight: chatMessages[index]['sender'] == 'You'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Display questions list as buttons
            if (chatMessages.isNotEmpty &&
                chatMessages.last['sender'] == 'Agent' &&
                chatMessages.last['message'] == 'Please select a question to learn more about resume improvement:') ...[
              ...questionsAndAnswers.keys.map((question) {
                return ElevatedButton(
                  onPressed: () => _handleOptionSelection(question),
                  child: Text(question),
                );
              }).toList(),
            ],
            // Display feedback options after answering
            if (chatMessages.isNotEmpty &&
                chatMessages.last['sender'] == 'Agent' &&
                chatMessages.last['message'] == 'Did this help you improve your resume? Please select an option below.') ...[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    chatMessages.add({'sender': 'You', 'message': 'Yes, it helped!'});
                  });
                  // Ask for more questions if satisfied
                  Future.delayed(Duration(seconds: 1), _askForMoreQuestions);
                },
                child: Text('Yes, it helped!'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    chatMessages.add({'sender': 'You', 'message': 'No, it didn\'t help.'});
                  });
                  // Provide further assistance or re-ask
                  _handleDissatisfaction();
                },
                child: Text('No, it didn\'t help.'),
              ),
            ],
            // Customer support button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  chatMessages.add({'sender': 'Agent', 'message': 'For further assistance, please contact support@hireflix.com.'});
                });
              },
              child: Text('Need further assistance? Contact support@hireflix.com'),
            ),
          ],
        ),
      ),
    );
  }
}
