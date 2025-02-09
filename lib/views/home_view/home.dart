import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/colors.dart';
import 'package:flutter_application_6/views/home_view/homeview.dart';
import 'package:flutter_application_6/views/orders_view/ordersview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedIndex = 0;
  List screenList = [
    const HomeView(),
    const OrdersView(),
    const HomeView(),
    const HomeView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedItemColor: AppColors.greenC,
        // ignore: prefer_const_constructors
        selectedLabelStyle: TextStyle(
          color: AppColors.greenC,
        ),
        selectedIconTheme: IconThemeData(
          color: AppColors.greenC,
        ),
        backgroundColor: const Color.fromARGB(255, 237, 233, 233),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Prices"),
          BottomNavigationBarItem(icon: Icon(Icons.person_sharp), label: "Profile"),
        ]),
    );
  }
}