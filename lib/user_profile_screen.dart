import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String dateOfBirth = '';

  // Text Editing Controllers for profile fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  // Load user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? 'N/A';
      lastName = prefs.getString('lastName') ?? 'N/A';
      email = prefs.getString('email') ?? 'N/A';
      phoneNumber = prefs.getString('phoneNumber') ?? 'N/A';
      dateOfBirth = prefs.getString('dob') ?? 'N/A';

      // Set controllers to the values
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      emailController.text = email;
      phoneNumberController.text = phoneNumber;
      dateOfBirthController.text = dateOfBirth;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Edit profile function
  void _editProfile() {
    setState(() {
      firstName = firstNameController.text;
      lastName = lastNameController.text;
      email = emailController.text;
      phoneNumber = phoneNumberController.text;
      dateOfBirth = dateOfBirthController.text;

      // Save changes to SharedPreferences
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('firstName', firstName);
        prefs.setString('lastName', lastName);
        prefs.setString('email', email);
        prefs.setString('phoneNumber', phoneNumber);
        prefs.setString('dob', dateOfBirth);
      });
    });
  }

  // Terms and Policy function
  void _openTermsAndPolicy() {
    print('Terms and Policy Button Clicked');
    // Navigate to terms page
  }

  // Subscribe Plan function
  void _subscribePlan() {
    print('Subscribe Plan Button Clicked');
    // Navigate to subscription plan screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editable Profile Info Section
              Text("First Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(hintText: "Enter your first name"),
              ),
              SizedBox(height: 15),

              Text("Last Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(hintText: "Enter your last name"),
              ),
              SizedBox(height: 15),

              Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Enter your email"),
              ),
              SizedBox(height: 15),

              Text("Phone Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(hintText: "Enter your phone number"),
              ),
              SizedBox(height: 15),

              Text("Date of Birth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                controller: dateOfBirthController,
                decoration: InputDecoration(hintText: "Enter your date of birth"),
              ),
              SizedBox(height: 20),

              // Edit Profile Button
              ElevatedButton(
                onPressed: _editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Save Changes'),
              ),
              SizedBox(height: 15),

              // Terms and Policy Button
              TextButton(
                onPressed: _openTermsAndPolicy,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: Text('Terms and Policies', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 15),

              // Subscription Plan Section
              Text("Choose Your Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Plan Cards
              Card(
                color: Colors.teal.shade100,
                elevation: 4,
                child: ListTile(
                  title: Text('Basic Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text('Basic features with limited access'),
                  trailing: ElevatedButton(
                    onPressed: _subscribePlan,
                    child: Text('Subscribe'),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Card(
                color: Colors.orange.shade100,
                elevation: 4,
                child: ListTile(
                  title: Text('Premium Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text('Full access to all features'),
                  trailing: ElevatedButton(
                    onPressed: _subscribePlan,
                    child: Text('Subscribe'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
