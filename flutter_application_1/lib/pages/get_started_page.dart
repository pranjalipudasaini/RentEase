import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_application_1/pages/property_details.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  Future<String?> _getLandlordId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      print("Error: Token is missing!");
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.key,
        'title': 'Property Management',
        'description':
            'Add and manage multiple properties, view property details and keep everything organized.'
      },
      {
        'icon': Icons.group,
        'title': 'Tenant Management',
        'description':
            'Keep track of tenant details, contact information and lease dates.'
      },
      {
        'icon': Icons.payment,
        'title': 'Online Payments',
        'description': 'Enable tenants to pay rent online with ease.'
      },
      {
        'icon': Icons.track_changes,
        'title': 'Payment Tracking',
        'description':
            'Monitor rent payments, view payment history and set reminders to ensure on-time payments.'
      },
      {
        'icon': Icons.build,
        'title': 'Maintenance Requests',
        'description':
            'Allow tenants to raise maintenance requests and track its status.'
      },
      {
        'icon': Icons.campaign,
        'title': 'Announcements',
        'description': 'Send important updates and announcements to tenants.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('062356'),
        title: const Text(
          'Get Started',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to RentEase, your very own rent management solution. We provide extensive features such as:',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  return FlipCard(
                    front: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: HexColor('062356'), width: 2), // Blue border
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: HexColor('062356'),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              features[index]
                                  ['icon'], // Use the icon from the list
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              features[index]['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: HexColor('062356'), width: 2), // Blue border
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white, // White background for the back
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            features[index]['description']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: HexColor('062356'), // Blue font color
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Retrieve landlordId from SharedPreferences
                  String? token = await _getLandlordId();

                  // If landlordId is null, you can pass a mock or default value
                  String tokenToPass = token ?? 'defaultLandlordId';

                  // Navigate to PropertyDetailsPage with the retrieved or default landlordId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailsPage(
                        token: tokenToPass,
                        isFromSignUp: true, // Set isFromSignUp to true
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('062356'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Increased radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20), // Larger button size
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Slightly larger font size
                    fontWeight: FontWeight.bold, // Optional for a bolder look
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
