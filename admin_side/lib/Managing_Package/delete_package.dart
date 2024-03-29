import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DeletePackage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delete Package:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DeletePackageForm(),
          ],
        ),
      ),
    );
  }
}

class DeletePackageForm extends StatefulWidget {
  @override
  _DeletePackageFormState createState() => _DeletePackageFormState();
}

class _DeletePackageFormState extends State<DeletePackageForm> {
  TextEditingController nameController = TextEditingController();

  void deletePackage() {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      FirebaseFirestore.instance.collection('packages').doc(name).delete().then((value) {
        nameController.clear();
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package deleted successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete package: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a package name')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Package Name'),
          ),
        ),
        const SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: deletePackage,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
