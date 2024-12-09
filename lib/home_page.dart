import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _hrContacts = [];
  bool _isLoadingHrContacts = false;
  String? _hrContactErrorMessage;

  // Use your published Google Sheet URL here
  final String _sheetUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vRvrM5grLLBwaBR1H05H75d-WA-ZFXYRG2UKQtUrj7gmsHJ5A4zgMeVMMd4ukn_P6LTCL_T-AP-eqCk/pub?output=csv';

  Future<void> _searchHrContacts(String companyName) async {
    setState(() {
      _isLoadingHrContacts = true;
      _hrContactErrorMessage = null;
      _hrContacts.clear(); // Clear previous results
    });

    try {
      final response = await http.get(Uri.parse(_sheetUrl));

      // Log the response status and body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Convert CSV to List of Maps
        List<String> lines = const LineSplitter().convert(response.body);
        if (lines.isEmpty) {
          setState(() {
            _hrContactErrorMessage = 'No data available in the Google Sheet.';
          });
          return;
        }

        List<String> headers = lines[0].split(',');

        for (var i = 1; i < lines.length; i++) {
          List<String> values = lines[i].split(',');
          Map<String, dynamic> contact = {};

          for (var j = 0; j < headers.length; j++) {
            // Avoid index out of range errors
            if (j < values.length) {
              contact[headers[j].toLowerCase().replaceAll(' ', '_')] =
                  values[j].trim(); // Trim whitespace
            }
          }
          _hrContacts.add(contact);
        }

        // Filter contacts based on company name
        setState(() {
          _hrContacts = _hrContacts.where((contact) {
            return contact['company_name'] != null &&
                contact['company_name']
                    .toString()
                    .toLowerCase()
                    .contains(companyName.toLowerCase());
          }).toList();
        });

        // Check if any contacts were found after filtering
        if (_hrContacts.isEmpty) {
          setState(() {
            _hrContactErrorMessage =
            'No HR contacts found for the company: $companyName.';
          });
        }
      } else {
        setState(() {
          _hrContactErrorMessage =
          'Failed to load HR contacts. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _hrContactErrorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoadingHrContacts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Contacts'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Container(
        // Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.yellowAccent, // Yellow color
              Colors.orange,        // Complementary orange color
            ],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Prevent overflow with scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHrContactSearch(),
              SizedBox(height: 20),
              _buildHrContactList(),
              SizedBox(height: 40), // Space before study tips
              _buildStudyTips(),
              SizedBox(height: 20),
              _buildStudyResources(),
              SizedBox(height: 20),
              _buildCodingPracticePlatforms(),
              SizedBox(height: 20),
              _buildInterviewWebsites(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHrContactSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search HR Contacts by Company Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Enter company name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _searchHrContacts(_searchController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            padding: EdgeInsets.symmetric(vertical: 12), // Better button height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('Search'),
        ),
      ],
    );
  }

  Widget _buildHrContactList() {
    if (_isLoadingHrContacts) {
      return Center(child: CircularProgressIndicator());
    }

    if (_hrContactErrorMessage != null) {
      return Center(child: Text(_hrContactErrorMessage!));
    }

    if (_hrContacts.isEmpty) {
      return Center(child: Text('No HR contacts available.'));
    }

    return Container(
      height: 400, // Set a fixed height for the list view to prevent overflow
      child: ListView.separated(
        itemCount: _hrContacts.length,
        itemBuilder: (context, index) {
          final contact = _hrContacts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5),
            elevation: 4, // Increased elevation for a better shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            child: ListTile(
              title: Text(
                contact['name'] ?? 'Name not available',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact['job_title'] != null) ...[
                    Row(
                      children: [
                        Icon(Icons.work, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(contact['job_title'] ?? 'Not available'),
                      ],
                    ),
                  ],
                  SizedBox(height: 5),
                  if (contact['company_name'] != null) ...[
                    Row(
                      children: [
                        Icon(Icons.business, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(contact['company_name'] ?? 'Not available'),
                      ],
                    ),
                  ],
                  SizedBox(height: 5),
                  if (contact['email'] != null) ...[
                    Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(contact['email'] ?? 'Not available'),
                      ],
                    ),
                  ],
                  SizedBox(height: 5),
                  if (contact['phone_number'] != null) ...[
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(contact['phone_number'] ?? 'Not available'),
                      ],
                    ),
                  ],
                  SizedBox(height: 5),
                  if (contact['linkedin_url'] != null) ...[
                    Row(
                      children: [
                        Icon(Icons.link, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(contact['linkedin_url']);
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text(
                            'LinkedIn Profile',
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  Widget _buildStudyTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Tips:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 6),
        _buildClickableText('1. Break down study sessions into smaller, focused intervals.', 'https://www.khanacademy.org'),
        _buildClickableText('2. Practice active recall rather than passive reading.', 'https://www.coursera.org'),
        _buildClickableText('3. Take frequent breaks to improve focus and memory retention.', 'https://www.udemy.com'),
      ],
    );
  }

  Widget _buildStudyResources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Resources:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 6),
        _buildClickableText('1. Khan Academy - Offers free lessons on various topics.', 'https://www.khanacademy.org'),
        _buildClickableText('2. Coursera - Offers online courses from top universities.', 'https://www.coursera.org'),
      ],
    );
  }

  Widget _buildCodingPracticePlatforms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coding Practice Platforms:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 6),
        _buildClickableText('1. LeetCode - Offers coding challenges to improve problem-solving skills.', 'https://www.leetcode.com'),
        _buildClickableText('2. CodeChef - Offers competitive programming contests and challenges.', 'https://www.codechef.com'),
      ],
    );
  }

  Widget _buildInterviewWebsites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interview Websites:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 6),
        _buildClickableText('1. InterviewBit - A platform for coding interview preparation.', 'https://www.interviewbit.com'),
        _buildClickableText('2. HackerRank - Offers coding challenges and interview preparation tools.', 'https://www.hackerrank.com'),
      ],
    );
  }

  Widget _buildClickableText(String text, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }
}
