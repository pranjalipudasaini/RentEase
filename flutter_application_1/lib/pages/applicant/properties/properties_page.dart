import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:flutter_application_1/pages/applicant/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/applicant/properties/view_property.dart';
import 'package:get/get.dart';

class ApplicantPropertiesPage extends StatefulWidget {
  @override
  _ApplicantPropertiesPageState createState() =>
      _ApplicantPropertiesPageState();
}

class _ApplicantPropertiesPageState extends State<ApplicantPropertiesPage> {
  final ApplicantPropertiesController propertyController =
      Get.put(ApplicantPropertiesController());
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs; // Reactive variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          String token = authService.token.value;

          if (token.isEmpty) {
            return const Center(
              child: Text(
                "Token not found. Please log in again.",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          return FutureBuilder<List<dynamic>>(
            future: propertyController.fetchAvailableProperties(token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: TextButton(
                    onPressed: () =>
                        propertyController.fetchAvailableProperties(token),
                    child:
                        const Text("Error loading properties. Tap to retry."),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF062356),
                    ),
                  ),
                );
              }

              final properties = snapshot.data ?? [];
              if (properties.isEmpty) {
                return const Center(
                  child: Text(
                    "No available properties.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: [
                  // Search Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) => searchQuery.value = value,
                            decoration: const InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Obx(() => searchQuery.value.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  searchController.clear();
                                  searchQuery.value = '';
                                },
                                child:
                                    const Icon(Icons.clear, color: Colors.grey),
                              )
                            : const SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Available Properties
                  Expanded(
                    child: Obx(() {
                      final filteredProperties = properties.where((property) {
                        final name =
                            property['propertyName']?.toLowerCase() ?? '';
                        return name.contains(searchQuery.value.toLowerCase());
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredProperties.length,
                        itemBuilder: (context, index) {
                          final property = filteredProperties[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ApplicantViewPropertyPage(
                                          property: property),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: const Color(0xFF062356),
                                  width: 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Property Name
                                  Text(
                                    property['propertyName'] ??
                                        'Unnamed Property',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF062356),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),

                                  // Address with location icon
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Color(0xFF062356)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          property['address'] ??
                                              'No address provided',
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6.0),

                                  // Owner Name
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          color: Color(0xFF062356)),
                                      const SizedBox(width: 6),
                                      Text(
                                        property['owner'] ?? 'Unknown Owner',
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
