import 'package:collection_report/models/collector.dart';
import 'package:flutter/material.dart';

class CollectorCreateModal extends StatelessWidget {
  const CollectorCreateModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController nameController = TextEditingController();

    return AlertDialog(
      title: const Text('New Collector'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Center(
              child: CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 60),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter name here',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name must not be empty.';
                      } else if (value.trim().isEmpty) {
                        return 'Name must be valid.';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final name = nameController.text.trim();

              await Collector.create(name);

              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Collector $name created.')),
              );
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Collector'),
        )
      ],
    );
  }
}
