import 'package:collection_report/models/collection.dart';
import 'package:flutter/material.dart';

class Collector {
  String id;
  late String name;
  late int position;
  late Collection monthly;
  late Collection daily;

  Collector(this.id, Map<String, dynamic> data) {
    name = data['name'];
    position = data['position'];
    monthly = Collection.fromJson('$name (Monthly)', data['monthly']);
    daily = Collection.fromJson('$name (Daily)', data['daily']);
  }

  num get collection {
    return monthly.total + daily.total;
  }

  Map<String, dynamic> exportNew() {
    return {
      'name': name,
      'position': position,
      'monthly': Collection.template().toJson(),
      'daily': Collection.template().toJson()
    };
  }

  Widget cardView() {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          const Icon(Icons.person_rounded, size: 90),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Monthly',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('${monthly.total}'),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            const Text(
                              'Daily',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('${daily.total}'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
