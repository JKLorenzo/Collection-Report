import 'package:collection_report/models/collector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewCollectorView extends StatelessWidget {
  const NewCollectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              final name = nameController.text;
              if (name.isNotEmpty) {
                await Collector.create(nameController.text);
                Navigator.of(context).pop(true);
              }
            },
            icon: const Icon(Icons.check),
          )
        ],
        centerTitle: true,
        title: const Text('New Collector'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SizedBox(height: 5),
          const Center(
            child: CircleAvatar(
              radius: 100,
              child: Icon(Icons.person, size: 160),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
              hintText: 'Enter name here',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
            ],
          ),
        ],
      ),
    );
  }
}
