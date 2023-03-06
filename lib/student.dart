import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentPageState();
}

class _StudentPageState extends State<Student> {
  // text fields' controllers
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();

  final CollectionReference _Students =
  FirebaseFirestore.instance.collection('Students');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _field1Controller.text = documentSnapshot['maSV'];
      _field2Controller.text = documentSnapshot['ngaySinh'];
      _field3Controller.text = documentSnapshot['gioiTinh'];
      _field4Controller.text = documentSnapshot['queQuan'];
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
                  decoration: const InputDecoration(labelText: 'Ma Sinh Vien'),
                ),
                TextField(
                  controller: _field2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Ngay Sinh',
                  ),
                ),
                TextField(
                  controller: _field3Controller,
                  decoration: const InputDecoration(
                    labelText: 'Gioi Tinh',
                  ),
                ),
                TextField(
                  controller: _field4Controller,
                  decoration: const InputDecoration(
                    labelText: 'Que Quan',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? maSV = _field1Controller.text;
                    final String? ngaySinh = _field2Controller.text;
                    final String? gioiTinh = _field3Controller.text;
                    final String? queQuan = _field4Controller.text;
                    if (maSV != null && ngaySinh != null || gioiTinh != null || queQuan != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _Students.add({"maSV": maSV, "ngaySinh": ngaySinh, 'gioiTinh': gioiTinh, 'queQuan': queQuan});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _Students
                            .doc(documentSnapshot!.id)
                            .update({"maSV": maSV, "ngaySinh": ngaySinh, 'gioiTinh': gioiTinh, 'queQuan': queQuan});
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
    await _Students.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Students'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _Students.snapshots(),
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
                            Text('Ma Sinh Vien: '+documentSnapshot['maSV']),
                            Text('Ngay Sinh: '+documentSnapshot['ngaySinh']),
                            Text('Gioi Tinh: '+documentSnapshot['gioiTinh']),
                            Text('Que Quan: '+documentSnapshot['queQuan']),
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
        child: const Icon(Icons.add,),
        backgroundColor: Colors.pink,
      ),
    );
  }
}