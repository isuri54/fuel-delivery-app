import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/colors.dart';
import 'package:flutter_application_6/consts/consts.dart';


class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: AppColors.greenC,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return OrderItemCard(
                fuelType: order['fuelType'],
                orderDate: order['orderDate'],
                quantity: order['quantity'],
              );
            },
          );
        },
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String fuelType;
  final String orderDate;
  final int quantity;

  const OrderItemCard({
    Key? key,
    required this.fuelType,
    required this.orderDate,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/engine-oil.png",
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fuelType,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Ordered on $orderDate",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "${quantity}L",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}