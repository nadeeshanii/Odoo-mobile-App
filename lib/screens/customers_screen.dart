// screens/customers_screen.dart
import 'package:flutter/material.dart';
import '../services/odoo_api_service.dart';

class CustomersScreen extends StatefulWidget {
  final String url;

  const CustomersScreen({super.key, required this.url});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List customers = [];
  bool isLoading = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  // =========================
  // LOAD CUSTOMERS
  // =========================
  Future<void> loadCustomers() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      final data = await OdooApiService.getCustomers(widget.url);
      setState(() => customers = data);
    } catch (e) {
      setState(() => errorText = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(title: const Text("Customers")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorText != null
          ? Center(child: Text("Error: $errorText"))
          : customers.isEmpty
          ? const Center(child: Text("No Customers Found"))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];

                String name = c['name'] ?? 'No Name';
                String email = c['email'] ?? '-';
                String phone = c['phone'] ?? '-';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    // 👤 Avatar
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF714B67),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    // 📌 Name
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // 📧 Email + 📞 Phone
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text("📧 $email"),
                        Text("📞 $phone"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
