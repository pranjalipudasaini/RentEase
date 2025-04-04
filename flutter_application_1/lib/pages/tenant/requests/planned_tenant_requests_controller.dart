import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MaintenanceRequestPageController extends GetxController {
  // Endpoint URL for your backend API
  final String apiUrl =
      'http://localhost:3000/request/createRequest'; // Change this to your server's URL

  Future<void> submitRequest(String title, String description, String priority,
      File? imageFile, Uint8List? imageBytes) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['priority'] = priority;

      // Add the image file if available
      if (imageFile != null) {
        var image = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(image);
      } else if (imageBytes != null) {
        // For web, send image bytes
        var image = http.MultipartFile.fromBytes('image', imageBytes,
            filename: 'image.jpg');
        request.files.add(image);
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        print('Request submitted successfully');
        // You can process the response if needed
      } else {
        print('Failed to submit request');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
