// screens/sales_orders_screen.dart
import 'package:flutter/material.dart';
import '../services/odoo_api_service.dart';

class SalesOrdersScreen extends StatefulWidget {

  final String url;

  const SalesOrdersScreen({
    super.key,
    required this.url,
  });

  @override
  State<SalesOrdersScreen> createState() =>
      _SalesOrdersScreenState();
}

class _SalesOrdersScreenState
    extends State<SalesOrdersScreen> {

  List orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  // =========================
  // LOAD ORDERS
  // =========================
  Future<void> loadOrders() async {

    setState(() => isLoading = true);

    final data = await OdooApiService.getSalesOrders(
      widget.url,
    );

    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  // =========================
  // STATUS COLOR
  // =========================
  Color getStatusColor(String state) {

    switch (state) {

      case "sale":
        return Colors.green;

      case "draft":
        return Colors.orange;

      case "cancel":
        return Colors.red;

      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Sales Orders"),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : orders.isEmpty

              ? const Center(
                  child: Text("No Sales Orders Found"),
                )

              : ListView.builder(
                  itemCount: orders.length,

                  itemBuilder: (context, index) {

                    final order = orders[index];

                    final String orderName =
                        order["name"] ?? "-";

                    final String state =
                        order["state"] ?? "draft";

                    final double total =
                        (order["amount_total"] ?? 0)
                            .toDouble();

                    String customer = "-";

                    if (order["partner_id"] is List &&
                        order["partner_id"].length > 1) {

                      customer =
                          order["partner_id"][1];
                    }

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF714B67),

                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          orderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const SizedBox(height: 5),

                            Text("Customer: $customer"),

                            Text(
                              "Total: \$${total.toStringAsFixed(2)}",
                            ),

                            const SizedBox(height: 5),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                color: getStatusColor(state),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),

                              child: Text(
                                state.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}