import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  _ManageOrdersPageState createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<QueryDocumentSnapshot> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadOrders() async {
    User? user = _auth.currentUser;
    print("Current user: ${user?.uid ?? 'Not signed in'}");
    if (user == null) {
      print("User not signed in, aborting order load");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in to manage orders")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      print("Fetching orders from Firestore...");
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();
      print("Fetched ${snapshot.docs.length} orders");
      setState(() {
        _orders = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading orders: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading orders: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<QueryDocumentSnapshot> get _filteredOrders {
    if (_searchQuery.isEmpty) {
      return _orders;
    }
    return _orders.where((order) {
      final orderId = order['orderId']?.toString().toLowerCase() ?? '';
      return orderId.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showUpdateOrderDialog(String orderId, String currentStatus) {
    final validStatuses = ['Processing', 'Prepared', 'Shipped', 'Delivered', 'Canceled'];
    String selectedStatus = validStatuses.contains(currentStatus)
        ? currentStatus
        : 'Processing';
    bool isCanceling = selectedStatus == 'Canceled';
    final TextEditingController cancelReasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Update Order: $orderId"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Update Order Status:"),
                    DropdownButton<String>(
                      value: selectedStatus,
                      items: validStatuses
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                            isCanceling = selectedStatus == 'Canceled';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedStatus = 'Canceled';
                          isCanceling = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Cancel Order", style: TextStyle(color: Colors.white)),
                    ),
                    if (isCanceling) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: cancelReasonController,
                        decoration: const InputDecoration(
                          labelText: "Reason for Cancellation",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      Map<String, dynamic> updateData = {'status': selectedStatus};
                      if (isCanceling && cancelReasonController.text.isNotEmpty) {
                        updateData['cancelReason'] = cancelReasonController.text;
                      } else if (isCanceling) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please provide a reason for cancellation")),
                        );
                        return;
                      }

                      await _firestore.collection('orders').doc(orderId).update(updateData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Order status updated to $selectedStatus")),
                      );
                      await _loadOrders();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error updating order: $e")),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Orders"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by Order ID",
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                    ? const Center(child: Text("No orders found"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = _filteredOrders[index];
                          final orderId = order.id;
                          final orderData = order.data() as Map<String, dynamic>;
                          final status = orderData['status']?.toString() ?? 'Processing';

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order ID: ${orderData['orderId'] ?? orderId}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Status: $status",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.green),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      _showUpdateOrderDialog(orderId, status);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}