import 'package:collection_report/models/collection.dart';

class Collector {
  String id;
  late String name;
  late Collection monthly;
  late Collection daily;

  Collector(this.id, Map<String, dynamic> data) {
    name = data['name'];
    monthly = Collection.fromJson('$name (Monthly)', data['monthly']);
      daily = Collection.fromJson('$name (Daily)', data['daily']);
  }

  Map<String, dynamic> info() {
    return {
      'name': name,
    };
  }
}
