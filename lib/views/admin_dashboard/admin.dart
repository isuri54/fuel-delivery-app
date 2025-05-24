import 'package:flutter/material.dart';
import 'package:flutter_application_6/views/admin_dashboard/fueltypes.dart';
import 'package:flutter_application_6/views/admin_dashboard/manageorders.dart';
import 'package:flutter_application_6/views/admin_dashboard/prices.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 40.0)),
          const Padding(padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0)),
          Container(
            height: 50,
            padding: const EdgeInsets.all(12.0),
            color: Colors.black12,
            child: const Center(
              child: Text("Welcome Admin !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          80.heightBox,
          Container(
            child: GestureDetector(
              onTap: () {
                Get.to(() => const FuelTypes());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none, 
                    children: [
                      Container(
                        height: 130,
                        width: 300,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            "Add Fuel Types",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20, 
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          30.heightBox,
          Container(
            child: GestureDetector(
              onTap: () {
                Get.to(() => const ChangePricesPage());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none, 
                    children: [
                      Container(
                        height: 130,
                        width: 300,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            "Change Prices",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20, 
                        child: Icon(
                          Icons.money,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          30.heightBox,
          Container(
            child: GestureDetector(
              onTap: () {
                Get.to(() => const ManageOrdersPage());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none, 
                    children: [
                      Container(
                        height: 130,
                        width: 300,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            "Manage Orders",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20, 
                        child: Icon(
                          Icons.update,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}