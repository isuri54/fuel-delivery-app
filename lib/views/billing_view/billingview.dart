import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BillingPage extends StatefulWidget {
  final String fuelType;
  final int quantity;
  final String deliveryType;
  final int shippingFee;

  BillingPage({
    required this.fuelType,
    required this.quantity,
    required this.deliveryType,
    required this.shippingFee,
  });

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = true;
  int fuelPrice = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchFuelPrice();
    fetchUserDetails();
  }

  Future<void> fetchFuelPrice() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('fuel_prices')
          .doc(widget.fuelType)
          .get();
      
      if (doc.exists) {
        setState(() {
          fuelPrice = doc['price'];
          totalPrice = (fuelPrice * widget.quantity) + widget.shippingFee;
        });
      }
    } catch (e) {
      print("Error fetching fuel price: $e");
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
      'userId': user.uid,
      'fuelType': widget.fuelType,
      'quantity': widget.quantity,
      'price': fuelPrice,
      'fuelTotal': fuelPrice * widget.quantity,
      'shippingFee': widget.shippingFee,
      'totalAmount': totalPrice,
      'deliveryType': widget.deliveryType,
      'orderDate': Timestamp.now(),
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
          : Padding(
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
                          Text(widget.fuelType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${widget.quantity}L"),
                          Text("Rs. ${fuelPrice.toStringAsFixed(2)}"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(widget.deliveryType, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Get by 20-23 Feb"),
                        Text("Rs. ${widget.shippingFee}"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Billing Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                  TextField(controller: contactController, decoration: InputDecoration(labelText: "Contact number")),
                  TextField(controller: addressController, decoration: InputDecoration(labelText: "Address"), maxLines: 2),
                  SizedBox(height: 20),
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
    );
  }
}
