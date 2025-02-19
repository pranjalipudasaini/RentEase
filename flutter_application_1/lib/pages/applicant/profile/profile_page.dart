import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/profile/profile_controller.dart';
import 'package:get/get.dart';

class ApplicantProfilePage extends GetView<ApplicantProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap the Column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/property1.jpg'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Pranjali Pudasaini",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "pudasainipranjali@gmail.com",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF062356)),
                    child: const Text("Edit",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection("Legal", [
                _buildListTile(Icons.person, "Contact Us"),
                _buildListTile(Icons.description, "Terms and Conditions"),
                _buildListTile(Icons.privacy_tip, "Privacy Policy"),
              ]),
              const SizedBox(height: 10),
              _buildSection("Other", [
                _buildListTile(Icons.settings, "Settings"),
                _buildListTile(Icons.delete, "Delete Account"),
                _buildListTile(Icons.account_balance, "Bank Details"),
                _buildListTile(Icons.account_balance_wallet, "Wallet"),
                _buildListTile(Icons.logout, "Log Out"),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Column(children: children),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      onTap: () {},
    );
  }
}
