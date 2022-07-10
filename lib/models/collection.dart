class Collection {
  String name;
  Map<String, num> data;
  List<num> addition;

  Collection(this.name, this.data, this.addition);

  factory Collection.fromJson(String name, Map<String, dynamic> data) {
    final _data = Map<String, num>.from(data['data']);
    final _addition = List<num>.from(data['addition']);

    return Collection(name, _data, _addition);
  }

  Map<String, dynamic> toJson() {
    return ({'data': data, 'addition': addition});
  }
}
