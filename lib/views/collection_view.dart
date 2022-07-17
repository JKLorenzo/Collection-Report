import 'package:collection_report/models/collection.dart';
import 'package:flutter/material.dart';

class CollectionView extends StatefulWidget {
  final Collection collection;
  const CollectionView({Key? key, required this.collection}) : super(key: key);

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  Widget build(BuildContext context) {
    final collection = widget.collection;

    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: 32,
        itemBuilder: (context, index) {
          index += 1;

          if (index == 32) {
            final addition = collection.addition.isNotEmpty
                ? collection.addition.reduce((
                    value,
                    element,
                  ) =>
                    value + element)
                : 0;

            return Card(
              child: ListTile(
                title: const Text('Addition'),
                subtitle: Text('$addition'),
              ),
            );
          }

          return Card(
            child: ListTile(
              title: Text('$index'),
              subtitle: Text('${collection.data['$index']}'),
            ),
          );
        },
      ),
    );
  }
}
