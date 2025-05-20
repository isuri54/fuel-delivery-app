import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/consts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FuelTypes extends StatefulWidget {
  const FuelTypes({super.key});

  @override
  State<FuelTypes> createState() => _FuelTypesState();
}

class _FuelTypesState extends State<FuelTypes> {

  final _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  final List<String> iconList = [
    AppAssets.petrol,
    AppAssets.petrol,
    AppAssets.diesel,
    AppAssets.diesel,
    AppAssets.kero,
    AppAssets.eng,
  ];

  final List<String> iconTitleList = [
    AppStrings.pt92,
    AppStrings.pt95,
    AppStrings.sds,
    AppStrings.ds,
    AppStrings.krs,
    AppStrings.eng,
  ];

  @override
  void initState() {
    super.initState();
    _loadFuelTypesFromDB();
  }

  Future<void> _loadFuelTypesFromDB() async {
    final snapshot = await _firestore.collection('fuel_types').get();
    setState(() {
      iconList.clear();
      iconTitleList.clear();
      for (var doc in snapshot.docs) {
        iconList.add(doc['imagePath']);
        iconTitleList.add(doc['name']);
      }
    });
  }

  Future<String?> _pickAndSaveImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File newImage = File(pickedFile.path);
        final directory = await getApplicationDocumentsDirectory();
        final fileName = path.basename(newImage.path);
        final savedImage = await newImage.copy('${directory.path}/$fileName');
        return savedImage.path;
      }
    }
    return null;
  }

  void _showAddFuelTypeModal() {
    String newFuelName = '';
    String? newFuelImagePath;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add New Fuel Type', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final imagePath = await _pickAndSaveImage();
                        if (imagePath != null) {
                          setState(() {
                            newFuelImagePath = imagePath;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: newFuelImagePath != null
                            ? FileImage(File(newFuelImagePath!))
                            : const AssetImage('assets/images/engine-oil.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Fuel Name'),
                      onChanged: (value) => newFuelName = value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (newFuelName.isNotEmpty && newFuelImagePath != null) {
                              await _firestore.collection('fuel_types').add({
                                'name': newFuelName,
                                'imagePath': newFuelImagePath,
                              });
                              await _loadFuelTypesFromDB();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
        leading: Icon(Icons.arrow_back),
        title: Text("Add Fuel Types"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: iconList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconList[index],
                        height: 50,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        iconTitleList[index],
                        style: const TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _showAddFuelTypeModal,
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, color: Colors.white),
                mini: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}