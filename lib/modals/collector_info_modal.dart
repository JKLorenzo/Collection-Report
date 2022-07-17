import 'package:collection_report/models/collector.dart';
import 'package:collection_report/views/collection_view.dart';
import 'package:flutter/material.dart';

class CollectorInfoModal extends StatefulWidget {
  final Collector collector;
  final void Function() onDelete;
  const CollectorInfoModal({
    Key? key,
    required this.collector,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CollectorInfoModal> createState() => _CollectorInfoModalState();
}

class _CollectorInfoModalState extends State<CollectorInfoModal> {
  @override
  Widget build(BuildContext context) {
    final collector = widget.collector;
    final onDelete = widget.onDelete;

    return AlertDialog(
      title: Center(
        child: Row(
          children: [
            Expanded(child: Text(collector.name)),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      collector.delete();
                      onDelete();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'ID:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Text(collector.id)
              ],
            ),
            const Divider(
              height: 40,
              thickness: 3,
            ),
            const Center(
              child: Text(
                'Collection Report',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'Daily:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Monthly:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(collector.daily.total().toString()),
                    Text(collector.monthly.total().toString()),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => CollectionView(collection: collector.daily),
            ));
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('Daily'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CollectionView(collection: collector.monthly),
              ),
            );
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('Monthly'),
        ),
      ],
    );
  }
}
