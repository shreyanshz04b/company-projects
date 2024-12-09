import 'package:shared_preferences/shared_preferences.dart';

void _registerUser() async {
  if (_formKey.currentState!.validate()) {
    // Save data using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', _firstNameController.text);
    prefs.setString('lastName', _lastNameController.text);
    prefs.setString('email', _emailController.text);
    prefs.setString('phoneNumber', _phoneNumberController.text);
    prefs.setString('password', _passwordController.text);  // Be cautious with sensitive data
    prefs.setString('dob', '${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}');

    // Navigate to Home Screen after successful registration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
