import 'package:collection_report/models/collection.dart';

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

  Map<String, dynamic> exportNew() {
    return {
      'name': name,
      'position': position,
      'monthly': Collection.template().toJson(),
      'daily': Collection.template().toJson()
    };
  }
}
