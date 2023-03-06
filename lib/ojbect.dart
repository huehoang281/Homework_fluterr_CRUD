import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ojbect extends StatefulWidget {
  const Ojbect({Key? key}) : super(key: key);

  @override
  State<Ojbect> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<Ojbect> {
  // text fields' controllers
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();

  final CollectionReference _Ojbect =
  FirebaseFirestore.instance.collection('Ojbect');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _field1Controller.text = documentSnapshot['maMH'];
      _field2Controller.text = documentSnapshot['tenMH'];
      _field3Controller.text = documentSnapshot['Mota'];
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
                  decoration: const InputDecoration(labelText: 'Ma Mon Hoc'),
                ),
                TextField(
                  controller: _field2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Ten Mon Hoc',
                  ),
                ),
                TextField(
                  controller: _field3Controller,
                  decoration: const InputDecoration(
                    labelText: 'Mo Ta',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? maMH = _field1Controller.text;
                    final String? tenMH = _field2Controller.text;
                    final String? Mota = _field3Controller.text;
                    if (maMH != null && tenMH != null || Mota != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _Ojbect.add({"maMH": maMH, "tenMH": tenMH, 'Mota': Mota});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _Ojbect
                            .doc(documentSnapshot!.id)
                            .update({"maMH": maMH, "tenMH": tenMH, 'Mota': Mota});
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
    await _Ojbect.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Ojbect '),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _Ojbect.snapshots(),
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
                            Text('Ma Mon Hoc: '+documentSnapshot['maMH']),
                            Text('Ten Mon Hoc: '+documentSnapshot['tenMH']),
                            Text('Mo ta: '+documentSnapshot['Mota']),
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