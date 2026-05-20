// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'customers_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String url;
  final Map<String, dynamic> user;

  const DashboardScreen({
    super.key,
    required this.url,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Odoo Dashboard"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👤 USER CARD
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF714B67)),
                title: Text(user['name'] ?? 'User'),
                subtitle: Text("UID: ${user['uid']}"),
              ),
            ),

            const SizedBox(height: 20),

            // 📦 MODULE TITLE
            const Text(
              "Sales Module",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 👇 MENU GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [

                  _menuCard(
                    icon: Icons.people,
                    title: "Customers",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CustomersScreen(url: url),
                        ),
                      );
                    },
                  ),

                  _menuCard(
                    icon: Icons.shopping_cart,
                    title: "Sales Orders",
                    onTap: () {},
                  ),

                  _menuCard(
                    icon: Icons.inventory,
                    title: "Products",
                    onTap: () {},
                  ),

                  _menuCard(
                    icon: Icons.dashboard,
                    title: "Reports",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎨 Reusable card widget
  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF714B67)),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}