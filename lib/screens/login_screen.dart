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
  String? dbError;

  bool isLoading = false;
  bool isLogging = false;

  final Color odooPurple = const Color(0xFF714B67);

  // =========================
  // FETCH DATABASES
  // =========================
  Future<void> fetchDatabases() async {
    setState(() => isLoading = true);

    try {
      final dbs = await OdooAuthService.fetchDatabases(urlController.text);

      if (!mounted) return;

      setState(() {
        databases = dbs;
        selectedDatabase = dbs.isNotEmpty ? dbs.first : null;
        dbError = null;
      });
    } catch (e) {
      final message = e.toString();
      setState(() => dbError = message);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $message")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login() async {
    setState(() => isLogging = true);

    final result = await OdooAuthService.login(
      urlController.text,
      selectedDatabase ?? "",
      usernameController.text,
      passwordController.text,
    );

    setState(() => isLogging = false);

    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DashboardScreen(url: urlController.text, user: result),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  // =========================
  // INPUT FIELD
  // =========================
  Widget buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: odooPurple),

        labelText: label,

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(14),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: odooPurple, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Container(
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(22),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // =========================
                // LOGO
                // =========================
                CircleAvatar(
                  radius: 35,
                  backgroundColor: odooPurple,

                  child: const Text(
                    "O",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  "Sign in to Odoo Sales ERP",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),

                const SizedBox(height: 20),

                // URL
                buildField("Server URL", urlController, Icons.link),

                const SizedBox(height: 12),

                // FETCH DB
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: fetchDatabases,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: odooPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Fetch Databases"),
                  ),
                ),

                const SizedBox(height: 8),

                if (dbError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      dbError!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 4),

                // DATABASE
                DropdownButtonFormField<String>(
                  value: selectedDatabase,

                  items: databases
                      .map((db) => DropdownMenuItem(value: db, child: Text(db)))
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedDatabase = value;
                    });
                  },

                  decoration: InputDecoration(
                    labelText: "Database",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // USERNAME
                buildField("Username", usernameController, Icons.person),

                const SizedBox(height: 12),

                // PASSWORD
                buildField(
                  "Password",
                  passwordController,
                  Icons.lock,
                  obscure: true,
                ),

                const SizedBox(height: 18),

                // LOGIN BUTTON
                SizedBox(
                  height: 48,

                  child: ElevatedButton(
                    onPressed: login,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: odooPurple,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: isLogging
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Login", style: TextStyle(fontSize: 16)),
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
