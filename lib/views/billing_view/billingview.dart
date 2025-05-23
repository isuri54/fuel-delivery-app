import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_6/consts/consts.dart';
import 'package:uuid/uuid.dart';

class BillingPage extends StatefulWidget {
  final String fuelType;
  final String selectedFuel;
  final int selectedQuantity;
  final int selectedFuelPrice;
  final String selectedDelivery;

  BillingPage({
    required this.fuelType,
    required this.selectedFuel,
    required this.selectedQuantity,
    required this.selectedFuelPrice,
    required this.selectedDelivery,
  });

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = true;
  int totalPrice = 0;
  int totalFuelPrice = 0;
  String orderId = '';
  final Uuid _uuid = Uuid();
  int pricePerLitre = 0;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    await fetchUserDetails(); 
    await _fetchFuelPrice();
    
    setState(() {
      isLoading = false;
      orderId = _generateOrderId();
    });
  }

  String _generateOrderId() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomId = _uuid.v4().split('-').first; 
    return 'ORD-${timestamp}-${randomId}'; 
  }

  Future<void> _fetchFuelPrice() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('fuel_types')
          .where('name', isEqualTo: widget.fuelType)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
      DocumentSnapshot doc = query.docs.first;
      if (doc['price'] != null) {
        pricePerLitre = doc['price'];
        setState(() {
          totalFuelPrice = pricePerLitre * widget.selectedQuantity;
          totalPrice = totalFuelPrice + 250;
        });
      } else {
        throw Exception("Price field missing for ${widget.fuelType}");
      }
    } else {
      print("No document found for fuelType: ${widget.fuelType}");
      throw Exception("Price data not found for ${widget.fuelType}");
    }
  } catch (e) {
    print("Error fetching fuel price: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error loading fuel price for ${widget.fuelType}. Please try again."),
      ),
    );
    setState(() {
      pricePerLitre = widget.selectedFuelPrice;
      totalFuelPrice = pricePerLitre * widget.selectedQuantity;
      totalPrice = totalFuelPrice + 250;
    });
  }
  }

  Future<void> fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      setState(() {
        nameController.text = doc['fullname'] ?? '';
        contactController.text = doc['contact'] ?? '';
        addressController.text = doc['address'] ?? '';
      });
    }
    setState(() => isLoading = false);
  }

  Future<void> placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fullname': nameController.text,
      'contact': contactController.text,
      'address': addressController.text,
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance.collection('orders').add({
      'orderId': orderId,
      'userId': user.uid,
      'fuelType': widget.selectedFuel,
      'quantity': widget.selectedQuantity,
      'price': widget.selectedFuelPrice,
      'fuelTotal': widget.selectedFuelPrice * widget.selectedQuantity,
      'shippingFee': 250, 
      'totalAmount': totalPrice,
      'deliveryType': widget.selectedDelivery,
      'orderDate': Timestamp.now(),
      The issue you’re encountering at 11:54 PM +0530 on Friday, May 23, 2025, in the OrdersView page arises because new orders placed via the BillingPage do not have a status field in Firestore, while the OrderItemCard widget expects a status field (defaulting to "Processing" if it’s missing). When you manually added status fields to previous orders in the database, those orders display correctly, but new orders lack this field, causing the exception. Let’s fix this by ensuring every new order includes a status field when it’s created.

Root Cause
In the placeOrder method of BillingPage, the order document is created without a status field:
dart

Copy
await FirebaseFirestore.instance.collection('orders').add({
  'orderId': orderId,
  'userId': user.uid,
  'fuelType': widget.selectedFuel,
  'quantity': widget.selectedQuantity,
  'price': pricePerLitre,
  'fuelTotal': totalFuelPrice,
  'shippingFee': 250,
  'totalAmount': totalPrice,
  'deliveryType': widget.selectedDelivery,
  'orderDate': Timestamp.now(),
});
The OrderItemCard widget in OrdersView attempts to access order['status'] with a fallback:
dart

Copy
status: order['status'] as String? ?? 'Processing',
However, if order['status'] is missing, this fallback works, but you mentioned an exception, suggesting there might be a mismatch or additional logic elsewhere (e.g., in Firestore security rules or another part of your app). Let’s ensure the status field is always set when creating a new order.
Solution
Update the placeOrder method in BillingPage to include a status field with a default value (e.g., "Processing") when creating a new order.
Optionally, update existing orders in Firestore to include the status field if they’re missing it (to handle any orders placed before this fix).
Step 1: Update placeOrder to Include status
Modify the placeOrder method in BillingPage to add a status field to every new order.

Updated placeOrder in BillingPage
Here’s the modified placeOrder method:

dart

Copy
Future<void> placeOrder() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'fullname': nameController.text,
    'contact': contactController.text,
    'address': addressController.text,
  }, SetOptions(merge: true));

  await FirebaseFirestore.instance.collection('orders').add({
    'orderId': orderId,
    'userId': user.uid,
    'fuelType': widget.selectedFuel,
    'quantity': widget.selectedQuantity,
    'price': pricePerLitre,
    'fuelTotal': totalFuelPrice,
    'shippingFee': 250,
    'totalAmount': totalPrice,
    'deliveryType': widget.selectedDelivery,
    'orderDate': Timestamp.now(),
    'status': 'Processing',
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Order placed successfully!"),
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Billing Information"), backgroundColor: Colors.green),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/engine-oil.png", 
                          width: 80, 
                          height: 80, 
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.selectedFuel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("${widget.selectedQuantity}L"),
                            Text("Rs. $pricePerLitre.00"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 400,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(widget.selectedDelivery, style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: const Color.fromARGB(137, 92, 91, 91),)),
                          Text("Get by 20-23 Feb"),
                          Text("Rs. 250"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Billing Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                    TextField(controller: contactController, decoration: InputDecoration(labelText: "Contact number")),
                    TextField(controller: addressController, decoration: InputDecoration(labelText: "Address"), maxLines: 2),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fuel Total:', style: TextStyle(fontSize: 16)),
                        Text('$totalFuelPrice', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Fee:', style: TextStyle(fontSize: 16)),
                        Text('Rs. 250', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 80),
                    Container(
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total: Rs. ${totalPrice.toStringAsFixed(2)}", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ElevatedButton(
                            onPressed: placeOrder,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                            child: Text("Place Order", style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}