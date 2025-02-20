import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_application_6/consts/consts.dart';
import 'package:flutter_application_6/consts/lists.dart';
import 'package:get/get.dart';

import '../../res/custombtn.dart';
import '../billing_view/billingview.dart';
import '../locationview/locationview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedFuelIndex = -1;
  int selectedDeliveryIndex = -1;
  String? selectedQuantity;
  int selectedFuelPrice = 0;

  List<String> iconList = [AppAssets.petrol,AppAssets.petrol,AppAssets.diesel,AppAssets.diesel,AppAssets.kero,AppAssets.eng,];
  List<String> items = [
    "1L","2L","3L","4L","5L","6L","7L","8L","9L","10L","11L","12L","13L","14L","15L","16L","17L","18L","19L","20L",
  ];
  
  List<String> iconTitleList = ["Octane 92 Petrol", "Octane 95 Petrol", " Super Diesel", "Diesel", "Kerosene", "Engine Oil"];
  List<String> btnList = ["Standard", "Urgent"];
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> fuelData = [];

  @override
  void initState() {
    super.initState();
    fetchFuelData();
  }

  Future<void> fetchFuelData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('fuel_prices').get();
      List<Map<String, dynamic>> tempList = [];

      for (var doc in querySnapshot.docs) {
        tempList.add({
          'name': doc['name'],
          'price': doc['price'],
        });
      }

      setState(() {
        fuelData = tempList;
      });
    } catch (e) {
      print("Error fetching fuel data: $e");
    }
  }

  void navigateToLocationPage() {
    if (selectedFuelIndex == -1 || selectedDeliveryIndex == -1 || selectedQuantity == null) {
      Get.snackbar("Error", "Please select all order details before proceeding.");
      return;
    }

    Get.to(() => BillingPage(
          fuelType: iconTitleList[selectedFuelIndex],
          selectedFuel: iconTitleList[selectedFuelIndex],
          selectedQuantity: int.parse(selectedQuantity!.replaceAll(RegExp(r'[^0-9]'), '')),
          selectedFuelPrice: selectedFuelPrice,
          selectedDelivery: btnList[selectedDeliveryIndex],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenC,
        elevation: 0.0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Home"),
            )
          ],
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(padding: EdgeInsets.only(top: 2.0)),
          const Padding(padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0)),
          Container(
            height: 100,
            padding: const EdgeInsets.all(12.0),
            color: Colors.black12,
            child: const Center(
              child: Text("Welcome to Fuela ! \n Your fuel, delivered anytime, anywhere. Sit back and let us keep you moving!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text("Select fuel type :", style: TextStyle(fontSize: 16),),
                ),
                Container(
                color: const Color.fromARGB(31, 161, 159, 159),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  height: 110,
                  child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: iconList.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSelected = selectedFuelIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFuelIndex = index;
                          selectedFuelPrice = fuelData.isNotEmpty ? fuelData[index]['price'] : 0;
                        });
                      },
                      child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.selectC : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Image.asset(
                            iconList[index],
                            width: 30,
                                        
                          ),
                          5.heightBox,
                          AppStyles.normal(title: iconTitleList[index], color: Colors.black),
                        ],
                      ),
                    ),
                  );
                }
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: Text("Quantity :", style: TextStyle(fontSize: 16),),
              ),
              Container(
                color: const Color.fromARGB(31, 161, 159, 159),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select Quantity (L)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedQuantity,
                    onChanged: (String? value) {
                      setState(() {
                        selectedQuantity = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 412,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all<double>(6),
                        thumbVisibility: WidgetStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: Text("Delivery : \n*Please select urgent only if you ran out of fuel mid-drive", style: TextStyle(fontSize: 16),),
                
              ),
              Container(
                color: const Color.fromARGB(31, 161, 159, 159),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 120.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: btnList.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = selectedDeliveryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDeliveryIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.selectC : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          children: [
                            AppStyles.normal(title: btnList[index], color: Colors.black),
                          ],
                        ),
                      ),
                    );
                  }
                ),
                ),
                
              ),
              20.heightBox,
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: CustomButton(
                    buttonText: "NEXT", 
                    onTap: () {
                      navigateToLocationPage();
                    },
                    textColor: Colors.black,
                    buttonColor: AppColors.greenC,
                  ),
                ),
              ),
              ],
              
            ),
            
          ),
        ],
      ),
    );
  }
}