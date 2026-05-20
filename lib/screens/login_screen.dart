// screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/odoo_auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> databases = [];
  String? selectedDatabase;

  bool isLoading = false;

  // =========================
  // FETCH DATABASES
  // =========================
  Future<void> fetchDatabases() async {
    setState(() => isLoading = true);

    try {
      final dbs = await OdooAuthService.fetchDatabases(
        urlController.text,
      );

      setState(() {
        databases = dbs;
        selectedDatabase = dbs.isNotEmpty ? dbs.first : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
    }
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login() async {
    final result = await OdooAuthService.login(
      urlController.text,
      selectedDatabase ?? "",
      usernameController.text,
      passwordController.text,
    );

    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            url: urlController.text,
            user: result,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(20),

            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // 🟣 TITLE
                  const Text(
                    "Odoo Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF714B67),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🌐 URL
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      labelText: "Server URL",
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔄 FETCH DB
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: fetchDatabases,
                      child: const Text("Fetch Databases"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 📂 DATABASE
                  DropdownButtonFormField<String>(
                    value: selectedDatabase,
                    items: databases
                        .map(
                          (db) => DropdownMenuItem(
                            value: db,
                            child: Text(db),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDatabase = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Select Database",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 👤 USERNAME
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔒 PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔑 LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        backgroundColor: const Color(0xFF714B67),
                      ),
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ⏳ LOADING
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}