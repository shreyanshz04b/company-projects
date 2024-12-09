import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyInfoPage extends StatefulWidget {
  @override
  _CompanyInfoPageState createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? companyData;
  bool isLoading = false;

  // Fetch company data from the PHP API
  Future<void> _fetchCompanyData(String companyName) async {
    setState(() {
      isLoading = true;
      companyData = null;
    });

    final url = Uri.parse('http://localhost:8012/fetch_company.php?company_name=$companyName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response Data: $data"); // Debugging line

        if (data.containsKey('error')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['error'])),
          );
        } else {
          setState(() {
            companyData = data;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to retrieve data")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // Helper method to get company name
  String getCompanyName() {
    return companyData?['name']?.isNotEmpty == true ? companyData!['name'] : "Company Information";
  }

  // Helper method for neon text style
  TextStyle _neonTextStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.cyanAccent,
      shadows: [
        Shadow(
          blurRadius: 20.0,
          color: Colors.cyanAccent,
          offset: Offset(0, 0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Finder', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellowAccent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Company',
                labelStyle: TextStyle(color: Colors.cyanAccent),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.cyanAccent),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _fetchCompanyData(_searchController.text);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(color: Colors.cyanAccent)
                : companyData != null
                ? Expanded(
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    Text(
                      getCompanyName(),
                      style: _neonTextStyle(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Overview: ${companyData?['overview'] ?? 'No Overview Available'}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Interview Tips: ${companyData?['interview_tips'] ?? 'No Tips Available'}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Culture: ${companyData?['culture'] ?? 'No Culture Info Available'}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "FAQs: ${companyData?['faqs'] ?? 'No FAQs Available'}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
                : Text(
              "No data available.",
              style: TextStyle(color: Colors.cyanAccent),
            ),
          ],
        ),
      ),
    );
  }
}
