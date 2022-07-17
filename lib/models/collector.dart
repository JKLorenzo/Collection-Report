import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection_report/models/collection.dart';
import 'package:collection_report/utils/session.dart';
import 'package:flutter/material.dart';

class Collector {
  String id;
  String name;
  int position;
  late Collection monthly;
  late Collection daily;

  Collector(
    this.id,
    this.name,
    this.position, {
    Collection? monthly,
    Collection? daily,
  }) {
    this.monthly = monthly ?? Collection.template();
    this.daily = daily ?? Collection.template();
  }

  factory Collector.fromJson(String id, Map<String, dynamic> data) {
    final name = data['name'];
    final position = data['position'];
    final monthly = Collection.fromJson('$name (Monthly)', data['monthly']);
    final daily = Collection.fromJson('$name (Daily)', data['daily']);

    return Collector(id, name, position, monthly: monthly, daily: daily);
  }

  Future<void> updatePosition(int position) async {
    this.position = position;

    await FirebaseFirestore.instance
        .collection(Session.period.asId())
        .doc(id)
        .update({'position': position});
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Monthly',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('${monthly.total()}'),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Daily',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('${daily.total()}'),
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

  Collector clearCollections() {
    monthly.clear();
    daily.clear();

    return this;
  }

  num totalCollection() {
    return monthly.total() + daily.total();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'monthly': monthly.toJson(),
      'daily': daily.toJson()
    };
  }
}
