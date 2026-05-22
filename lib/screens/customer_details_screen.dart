// screens/customer_details_screen.dart
import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Map customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    String textValue(dynamic value, [String fallback = '-']) {
      if (value == null) return fallback;
      if (value is String && value.trim().isEmpty) return fallback;
      return value.toString();
    }

    final String name = textValue(customer['name'], 'No Name');

    final String email = textValue(customer['email']);

    final String phone = textValue(customer['phone']);

    final String mobile = textValue(customer['mobile']);

    final String street = textValue(customer['street']);

    final String city = textValue(customer['city']);

    final String company = textValue(customer['company_type']);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(title: const Text("Customer Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // 👤 PROFILE CARD
            Card(
              elevation: 3,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF714B67),

                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(company, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📋 INFO CARD
            Card(
              elevation: 2,

              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Email"),
                    subtitle: Text(email),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Phone"),
                    subtitle: Text(phone),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.smartphone),
                    title: const Text("Mobile"),
                    subtitle: Text(mobile),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text("Address"),
                    subtitle: Text("$street, $city"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
