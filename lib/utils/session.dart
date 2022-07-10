import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection_report/models/collector.dart';
import 'package:collection_report/utils/period.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Period _period;
late List<Collector> _collectors;
late SharedPreferences _preferences;

bool _isNext = false;

class Session {
  static Period get period {
    return _period;
  }

  static List<Collector> get collectors {
    return _collectors;
  }

  static SharedPreferences get preferences {
    return _preferences;
  }

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();

    final now = DateTime.now();
    var month = _preferences.getInt('month');
    var year = _preferences.getInt('year');

    if (month == null) {
      month = now.month;
      await _preferences.setInt('month', month);
    }

    if (year == null) {
      year = now.year;
      await _preferences.setInt('year', year);
    }

    _period = Period(month, year);

    _collectors = [];
  }

  static Future<void> load() async {
    final id = _period.asId();
    var data = await FirebaseFirestore.instance.collection(id).get();

    if (_isNext) {
      _isNext = false;

      if (data.docs.isEmpty) {
        // Import collectors from previous period
        for (final collector in collectors) {
          await FirebaseFirestore.instance.collection(id).add(collector.info());
        }
      }

      data = await FirebaseFirestore.instance.collection(id).get();
    }

    _collectors = data.docs.map((e) => Collector(e.id, e.data())).toList();
  }

  static void next() {
    _period.nextMonth();
    _isNext = true;
  }

  static void back() {
    _period.prevMonth();
  }
}