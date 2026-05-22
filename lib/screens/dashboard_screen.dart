// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'create_customer_screen.dart';
import 'customers_screen.dart';
import 'sales_orders_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String url;
  final Map user;

  const DashboardScreen({super.key, required this.url, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  // Odoo Colors
  final Color odooPurple = const Color(0xFF714B67);

  final Color bgColor = const Color(0xFFF5F5F7);

  void _openCustomers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomersScreen(url: widget.url)),
    );
  }

  void _openSalesOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SalesOrdersScreen(url: widget.url)),
    );
  }

  void _openCreateCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateCustomerScreen(url: widget.url)),
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      // ==================================================
      // APP BAR
      // ==================================================
      appBar: AppBar(
        backgroundColor: odooPurple,
        elevation: 0,

        titleSpacing: 16,

        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Center(
                child: Text(
                  "O",
                  style: TextStyle(
                    color: odooPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Odoo Sales",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Text(
                  "Mobile ERP",
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),

        actions: [
          _appBarButton(Icons.search_rounded),

          const SizedBox(width: 8),

          _appBarButton(Icons.notifications_none_rounded),

          const SizedBox(width: 14),
        ],
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =============================================
            // WELCOME CARD
            // =============================================
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),

                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: odooPurple,

                    child: Text(
                      widget.user['name']
                              ?.toString()
                              .substring(0, 1)
                              .toUpperCase() ??
                          "U",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Welcome back,",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.user['name'] ?? "User",

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Sales Management Dashboard",

                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =============================================
            // KPI SECTION
            // =============================================
            Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    title: "Customers",
                    value: "1,092",
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF10B981),
                    bgColor: const Color(0xFFD1FAE5),
                    trend: "+12%",
                    trendUp: true,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _kpiCard(
                    title: "Orders",
                    value: "248",
                    icon: Icons.receipt_long_outlined,
                    iconColor: const Color(0xFF3B82F6),
                    bgColor: const Color(0xFFDBEAFE),
                    trend: "+8%",
                    trendUp: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    title: "Revenue",
                    value: "\$84K",
                    icon: Icons.attach_money,
                    iconColor: odooPurple,
                    bgColor: const Color(0xFFF3E8FF),
                    trend: "+5%",
                    trendUp: true,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _kpiCard(
                    title: "Pending",
                    value: "34",
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    bgColor: const Color(0xFFFEF3C7),
                    trend: "3 late",
                    trendUp: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // =============================================
            // MODULE TITLE
            // =============================================
            const Text(
              "Modules",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            // =============================================
            // MODULE GRID
            // =============================================
            GridView.count(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              childAspectRatio: 1.2,

              children: [
                _moduleCard(
                  title: "Customers",
                  subtitle: "1,092 total",
                  icon: Icons.people_outline,
                  iconColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFD1FAE5),
                  onTap: _openCustomers,
                ),

                _moduleCard(
                  title: "Sales Orders",
                  subtitle: "248 orders",
                  icon: Icons.receipt_long_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  bgColor: const Color(0xFFDBEAFE),
                  onTap: _openSalesOrders,
                ),

                _moduleCard(
                  title: "Create Customer",
                  subtitle: "Add a new contact",
                  icon: Icons.person_add_alt_1_outlined,
                  iconColor: odooPurple,
                  bgColor: const Color(0xFFF3E8FF),
                  onTap: _openCreateCustomer,
                ),

                _moduleCard(
                  title: "Reports",
                  subtitle: "Analytics",
                  icon: Icons.bar_chart_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                  onTap: () => _showComingSoon('Reports'),
                ),
              ],
            ),
          ],
        ),
      ),

      // ==================================================
      // BOTTOM NAVIGATION
      // ==================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              break;
            case 1:
              _openSalesOrders();
              break;
            case 2:
              _openCustomers();
              break;
            case 3:
              _showComingSoon('Reports');
              break;
            case 4:
              _showComingSoon('Profile');
              break;
          }
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: odooPurple,

        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: "Orders",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: "Customers",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: "Reports",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ==================================================
  // APP BAR BUTTON
  // ==================================================
  Widget _appBarButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),

        borderRadius: BorderRadius.circular(10),
      ),

      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // ==================================================
  // KPI CARD
  // ==================================================
  Widget _kpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String trend,
    required bool trendUp,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: bgColor,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: iconColor),
              ),

              Row(
                children: [
                  Icon(
                    trendUp ? Icons.trending_up : Icons.trending_down,

                    color: trendUp ? Colors.green : Colors.red,

                    size: 16,
                  ),

                  const SizedBox(width: 3),

                  Text(
                    trend,

                    style: TextStyle(
                      fontSize: 12,
                      color: trendUp ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // MODULE CARD
  // ==================================================
  Widget _moduleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: bgColor,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: iconColor, size: 26),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
