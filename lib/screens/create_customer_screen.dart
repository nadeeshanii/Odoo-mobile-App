import 'package:flutter/material.dart';

import '../services/odoo_api_service.dart';

class CreateCustomerScreen extends StatefulWidget {
  final String url;

  const CreateCustomerScreen({super.key, required this.url});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool isSaving = false;
  String companyType = 'person';

  Future<void> saveCustomer() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await OdooApiService.createCustomer(
        widget.url,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        mobile: mobileController.text.trim(),
        street: streetController.text.trim(),
        city: cityController.text.trim(),
        companyType: companyType,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create customer: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    streetController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Create Customer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: companyType,
                  items: const [
                    DropdownMenuItem(value: 'person', child: Text('Person')),
                    DropdownMenuItem(value: 'company', child: Text('Company')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => companyType = value);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : saveCustomer,
                    child: isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Customer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}