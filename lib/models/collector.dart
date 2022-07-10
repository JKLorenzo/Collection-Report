class Collector {
  String id;
  late String name;

  Collector(this.id, Map<String, dynamic> data) {
    name = data['name'];
  }

  Map<String, dynamic> info() {
    return {
      'name': name,
    };
  }
}
