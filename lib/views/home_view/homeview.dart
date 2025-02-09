import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_application_6/consts/consts.dart';
import 'package:flutter_application_6/consts/lists.dart';
import 'package:get/get.dart';

import '../../res/custombtn.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = -1;
  int selectedBtn = -1;

  final List<String> items = [
    "1L","2L","3L","4L","5L","6L","7L","8L","9L","10L","11L","12L","13L","14L","15L","16L","17L","18L","19L","20L",
  ];
  String? selectedValue;

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
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
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
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
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
                      bool isSelected = selectedBtn == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBtn = index;
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