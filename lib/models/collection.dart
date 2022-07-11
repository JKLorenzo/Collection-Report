class Collection {
  String name;
  late Map<String, num> data;
  late List<num> addition;

  Collection(this.name, {Map<String, num>? data, List<num>? addition}) {
    Map<String, num> emptyData = {};
    for (var i = 1; i <= 31; i++) {
      emptyData.putIfAbsent('$i', () => 0);
    }

    this.data = data ?? emptyData;
    this.addition = addition ?? [];
  }

  num get total {
    var total = data.values.reduce((value, element) => element + value);
    if (addition.isNotEmpty) {
      total += addition.reduce((value, element) => element + value);
    }
    return total;
  }

  factory Collection.template() {
    return Collection('template');
  }

  factory Collection.fromJson(String name, Map<String, dynamic> data) {
    final _data = Map<String, num>.from(data['data']);
    final _addition = List<num>.from(data['addition']);

    return Collection(name, data: _data, addition: _addition);
  }

  Map<String, dynamic> toJson() {
    return {'data': data, 'addition': addition};
  }
}
