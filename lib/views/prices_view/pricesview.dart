import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PricesView extends StatefulWidget {
  const PricesView({super.key});

  @override
  _PricesViewState createState() => _PricesViewState();
}

class _PricesViewState extends State<PricesView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  List<QueryDocumentSnapshot> _fuelTypes = [];

  @override
  void initState() {
    super.initState();
    _loadFuelTypes();
  }

  Future<void> _loadFuelTypes() async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign in to see fuel prices")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      print("Fetching fuel types from Firestore...");
      QuerySnapshot snapshot = await _firestore.collection('fuel_types').get();
      print("Fetched ${snapshot.docs.length} fuel types");
      setState(() {
        _fuelTypes = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading fuel types: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading fuel types: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("See Fuel Prices"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _fuelTypes.isEmpty
                    ? const Center(child: Text("No fuel types found"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _fuelTypes.length,
                        itemBuilder: (context, index) {
                          final fuel = _fuelTypes[index];
                          final fuelData = fuel.data() as Map<String, dynamic>;
                          final fuelName = fuelData['name']?.toString() ?? 'Unknown';
                          final price = fuelData['price']?.toString() ?? '0';

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
                                          fuelName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Price: Rs. $price.00",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
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
}