import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection_report/models/collection.dart';
import 'package:collection_report/utils/session.dart';
import 'package:flutter/material.dart';

const quota = 170000;

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

  static Future<void> create(String name) async {
    final collector = Collector('', name, Session.collectors.length);
    await FirebaseFirestore.instance
        .collection(Session.period.asId())
        .add(collector.toJson());
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

  Future<void> delete() {
    return FirebaseFirestore.instance
        .collection(Session.period.asId())
        .doc(id)
        .delete();
  }

  String rank() {
    final collectors = [...Session.collectors];
    collectors.retainWhere((element) => element.totalCollection() >= quota);
    collectors
        .sort((a, b) => a.totalCollection() > b.totalCollection() ? 0 : 1);

    switch (collectors.indexOf(this)) {
      case 0:
        return '(1st)';
      case 1:
        return '(2nd)';
      case 2:
        return '(3rd)';
      default:
        return '';
    }
  }

  Widget cardView(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 30, 5),
        child: Row(
          children: [
            const Icon(Icons.person_rounded, size: 80),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (rank().isNotEmpty) Text(' ${rank()}')
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('${totalCollection()}'),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
