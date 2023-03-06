import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Class extends StatefulWidget {
  const Class({Key? key}) : super(key: key);

  @override
  State<Class> createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<Class> {
  // text fields' controllers
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();

  final CollectionReference _Class =
  FirebaseFirestore.instance.collection('Class');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _field1Controller.text = documentSnapshot['maLH'];
      _field2Controller.text = documentSnapshot['tenLop'];
      _field3Controller.text = documentSnapshot['slSV'];
      _field4Controller.text = documentSnapshot['maGV'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _field1Controller,
                  decoration: const InputDecoration(labelText: 'Ma Lop Hoc'),
                ),
                TextField(
                  controller: _field2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Ten Lop',
                  ),
                ),
                TextField(
                  controller: _field3Controller,
                  decoration: const InputDecoration(
                    labelText: 'So Luong SV',
                  ),
                ),
                TextField(
                  controller: _field4Controller,
                  decoration: const InputDecoration(
                    labelText: 'Ma Giang Vien',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? maLH = _field1Controller.text;
                    final String? tenLop = _field2Controller.text;
                    final String? slSV = _field3Controller.text;
                    final String? maGV = _field4Controller.text;
                    if (maLH != null && tenLop != null || slSV != null || maGV != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _Class.add({"maLH": maLH, "tenLop": tenLop, 'slSV': slSV, 'maGV': maGV});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _Class
                            .doc(documentSnapshot!.id)
                            .update({"maLH": maLH, "tenLop": tenLop, 'slSV': slSV, 'maGV': maGV});
                      }

                      // Clear the text fields
                      _field1Controller.text = '';
                      _field1Controller.text = '';
                      _field1Controller.text = '';
                      _field1Controller.text= '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _Class.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('ClassRooms '),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _Class.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: '+documentSnapshot.reference.id.toString()),
                            Text('Ma Lop Hoc: '+documentSnapshot['maLH']),
                            Text('Ten Lop: '+documentSnapshot['tenLop']),
                            Text('So luong SV: '+documentSnapshot['slSV']),
                            Text('Ma GV: '+documentSnapshot['maGV']),
                          ],
                        )
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}