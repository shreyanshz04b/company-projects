import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSheetApi {
  final String apiKey = 'AIzaSyBupO4wyCNmEQWSxeuPzp9-fgrGsm-62Eo'; // Replace with your API key
  final String spreadsheetId = '1txEQHd0MiyaFCxyAyEOh1zP8CeYVXAs_bKR_10fEmuU'; // Replace with your Spreadsheet ID
  final String range = 'register'; // Replace with your sheet name if different

  // Function to send data to the Google Sheet
  Future<void> sendToGoogleSheet(String firstName, String lastName, String email, String phoneNumber, String password, DateTime dob) async {
    final url = Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range:append?valueInputOption=RAW&key=$apiKey');

    // Prepare data to be sent to the sheet
    final data = {
      "values": [
        [firstName, lastName, email, phoneNumber, password, dob.toIso8601String()]
      ]
    };

    // Make the request to append data to the sheet
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Data added successfully!');
    } else {
      print('Failed to add data: ${response.body}');
    }
  }
}
