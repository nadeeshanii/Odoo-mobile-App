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
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);

    final data = await OdooApiService.getCustomers(widget.url);

    setState(() {
      customers = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, i) {
                final c = customers[i];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Color(0xFF714B67),
                    ),
                    title: Text(c['name'] ?? ''),
                    subtitle: Text(
                      "${c['email'] ?? ''}\n${c['phone'] ?? ''}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}